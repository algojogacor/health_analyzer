import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/sport_mode.dart';
import '../../providers/health_provider.dart';
import '../../services/fitness_profile_service.dart';
import '../../services/onboarding_service.dart';
import '../../services/training_goal_service.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/info_panel.dart';
import '../../shared/widgets/premium_card.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const OnboardingPage({super.key, required this.onComplete});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _maxHrController = TextEditingController();
  final _restingHrController = TextEditingController();
  final _stepsController = TextEditingController(text: '10000');
  final _weeklyDistanceController = TextEditingController(text: '20');

  int _page = 0;
  bool _saving = false;
  bool _requestingHealth = false;
  bool? _healthGranted;
  String _unitSystem = 'metric';
  int _activeDays = 5;
  int _sleepHours = 8;
  final _favoriteSports = <String>{
    'walking',
    'outdoor_running',
    'outdoor_cycling',
  };

  @override
  void initState() {
    super.initState();
    _loadExisting();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _weightController.dispose();
    _maxHrController.dispose();
    _restingHrController.dispose();
    _stepsController.dispose();
    _weeklyDistanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == 3;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: _ProgressHeader(page: _page),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (value) => setState(() => _page = value),
                children: [
                  _WelcomeStep(onSkip: _finish),
                  _HealthConnectStep(
                    granted: _healthGranted,
                    requesting: _requestingHealth,
                    onRequest: _requestHealthPermission,
                  ),
                  _ProfileGoalsStep(
                    nameController: _nameController,
                    weightController: _weightController,
                    maxHrController: _maxHrController,
                    restingHrController: _restingHrController,
                    stepsController: _stepsController,
                    weeklyDistanceController: _weeklyDistanceController,
                    unitSystem: _unitSystem,
                    activeDays: _activeDays,
                    sleepHours: _sleepHours,
                    onUnitChanged:
                        (value) => setState(() => _unitSystem = value),
                    onActiveDaysChanged:
                        (value) => setState(() => _activeDays = value),
                    onSleepHoursChanged:
                        (value) => setState(() => _sleepHours = value),
                  ),
                  _FavoriteSportsStep(
                    selected: _favoriteSports,
                    onToggle: _toggleSport,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Row(
                children: [
                  if (_page > 0)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saving ? null : _previous,
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('Back'),
                      ),
                    )
                  else
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _saving ? null : _finish,
                        icon: const Icon(Icons.skip_next_outlined),
                        label: const Text('Skip'),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : (isLast ? _finish : _next),
                      icon:
                          _saving
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : Icon(
                                isLast ? Icons.check : Icons.chevron_right,
                              ),
                      label: Text(
                        _saving ? 'Saving' : (isLast ? 'Finish setup' : 'Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadExisting() async {
    final profile = await ref.read(onboardingServiceProvider).loadProfile();
    final fitness = await ref.read(fitnessProfileProvider.future);
    final goals = await ref.read(trainingGoalsProvider.future);
    if (!mounted) return;
    setState(() {
      _nameController.text = profile.displayName;
      _unitSystem = profile.unitSystem;
      _weightController.text = profile.bodyWeightKg?.toStringAsFixed(1) ?? '';
      _maxHrController.text = fitness.maxHeartRate?.toString() ?? '';
      _restingHrController.text = fitness.restingHeartRate?.toString() ?? '';
      _stepsController.text = goals.dailySteps.toString();
      _weeklyDistanceController.text = goals.weeklyDistanceKm.toStringAsFixed(
        goals.weeklyDistanceKm.truncateToDouble() == goals.weeklyDistanceKm
            ? 0
            : 1,
      );
      _activeDays = goals.weeklyActiveDays;
      _sleepHours = (goals.sleepTargetMinutes / 60).round().clamp(4, 12);
    });
  }

  void _next() {
    final next = (_page + 1).clamp(0, 3);
    _pageController.animateToPage(
      next,
      duration: AppMotion.standard,
      curve: AppMotion.curve,
    );
  }

  void _previous() {
    final previous = (_page - 1).clamp(0, 3);
    _pageController.animateToPage(
      previous,
      duration: AppMotion.standard,
      curve: AppMotion.curve,
    );
  }

  Future<void> _requestHealthPermission() async {
    setState(() => _requestingHealth = true);
    final granted = await ref.read(healthServiceProvider).requestPermissions();
    if (!mounted) return;
    setState(() {
      _healthGranted = granted;
      _requestingHealth = false;
    });
  }

  void _toggleSport(String key) {
    setState(() {
      if (_favoriteSports.contains(key)) {
        if (_favoriteSports.length > 1) _favoriteSports.remove(key);
      } else {
        _favoriteSports.add(key);
      }
    });
  }

  Future<void> _finish() async {
    setState(() => _saving = true);
    final onboarding = ref.read(onboardingServiceProvider);
    final weight = double.tryParse(_weightController.text.trim());
    await onboarding.saveProfile(
      OnboardingProfile(
        displayName: _nameController.text.trim(),
        unitSystem: _unitSystem,
        bodyWeightKg: weight == null || weight <= 0 ? null : weight,
      ),
    );
    await ref
        .read(fitnessProfileServiceProvider)
        .saveProfile(
          FitnessProfile(
            maxHeartRate: int.tryParse(_maxHrController.text.trim()),
            restingHeartRate: int.tryParse(_restingHrController.text.trim()),
          ),
        );
    await ref
        .read(trainingGoalServiceProvider)
        .saveGoals(
          TrainingGoals(
            dailySteps: _intValue(
              _stepsController.text,
              10000,
            ).clamp(1000, 50000),
            weeklyActiveDays: _activeDays.clamp(1, 7),
            weeklyActiveMinutes: (_activeDays * 30).clamp(30, 1500),
            weeklyDistanceKm: _doubleValue(
              _weeklyDistanceController.text,
              20,
            ).clamp(0, 500),
            sleepTargetMinutes: (_sleepHours * 60).clamp(240, 720),
          ),
        );
    await onboarding.saveFavoriteSports(_favoriteSports);
    await onboarding.complete();
    ref
      ..invalidate(onboardingCompletedProvider)
      ..invalidate(fitnessProfileProvider)
      ..invalidate(trainingGoalsProvider)
      ..invalidate(trainingInsightsProvider);
    if (!mounted) return;
    setState(() => _saving = false);
    widget.onComplete();
  }

  int _intValue(String raw, int fallback) {
    return int.tryParse(raw.trim()) ?? fallback;
  }

  double _doubleValue(String raw, double fallback) {
    return double.tryParse(raw.trim()) ?? fallback;
  }
}

class _ProgressHeader extends StatelessWidget {
  final int page;

  const _ProgressHeader({required this.page});

  @override
  Widget build(BuildContext context) {
    final labels = ['Welcome', 'Access', 'Goals', 'Sports'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Health Analyzer',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        Row(
          children: List.generate(labels.length, (index) {
            final active = index <= page;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == labels.length - 1 ? 0 : 8,
                ),
                child: AnimatedContainer(
                  duration: AppMotion.fast,
                  height: 5,
                  decoration: BoxDecoration(
                    color:
                        active ? AppTheme.cyan : Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          labels[page],
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _StepScaffold extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Widget> children;

  const _StepScaffold({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        AccentIconBox(icon: icon, color: AppTheme.cyan, size: 54),
        const SizedBox(height: 18),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkMuted
                    : AppTheme.muted,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        ...children,
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  final VoidCallback onSkip;

  const _WelcomeStep({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.auto_awesome,
      title: 'Your fitness data, finally useful.',
      subtitle:
          'Set up the basics once. The app stays local-first, uses your Turso when configured, and keeps AI context sanitized by default.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SetupRow(
                icon: Icons.health_and_safety_outlined,
                title: 'Health Connect',
                body: 'Read wearable data when permission is granted.',
              ),
              SizedBox(height: 14),
              _SetupRow(
                icon: Icons.route_outlined,
                title: 'Workout tracking',
                body: 'GPS only runs when you start an activity.',
              ),
              SizedBox(height: 14),
              _SetupRow(
                icon: Icons.lock_outline,
                title: 'Privacy first',
                body: 'Routes and AI context stay controlled by you.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: onSkip,
          child: const Text('Use defaults for now'),
        ),
      ],
    );
  }
}

class _HealthConnectStep extends StatelessWidget {
  final bool? granted;
  final bool requesting;
  final Future<void> Function() onRequest;

  const _HealthConnectStep({
    required this.granted,
    required this.requesting,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.health_and_safety_outlined,
      title: 'Connect health signals.',
      subtitle:
          'Health Analyzer can read steps, sleep, heart rate, SpO2, HRV, stress, and calories only when Health Connect exposes them. Missing sensors are shown as unavailable, not guessed.',
      children: [
        InfoPanel(
          icon:
              granted == true
                  ? Icons.verified_user_outlined
                  : Icons.info_outline,
          title:
              granted == true
                  ? 'Health access granted'
                  : 'Permission can be changed later',
          body:
              granted == true
                  ? 'Great. Dashboard and AI summaries can use real wearable data when available.'
                  : 'If your Xiaomi Smart Band does not export a signal, the app will keep that metric unavailable instead of fabricating it.',
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: requesting ? null : onRequest,
          icon:
              requesting
                  ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : const Icon(Icons.lock_open_outlined),
          label: Text(requesting ? 'Opening permissions' : 'Request access'),
        ),
      ],
    );
  }
}

class _ProfileGoalsStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController weightController;
  final TextEditingController maxHrController;
  final TextEditingController restingHrController;
  final TextEditingController stepsController;
  final TextEditingController weeklyDistanceController;
  final String unitSystem;
  final int activeDays;
  final int sleepHours;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<int> onActiveDaysChanged;
  final ValueChanged<int> onSleepHoursChanged;

  const _ProfileGoalsStep({
    required this.nameController,
    required this.weightController,
    required this.maxHrController,
    required this.restingHrController,
    required this.stepsController,
    required this.weeklyDistanceController,
    required this.unitSystem,
    required this.activeDays,
    required this.sleepHours,
    required this.onUnitChanged,
    required this.onActiveDaysChanged,
    required this.onSleepHoursChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      icon: Icons.tune_outlined,
      title: 'Tune your baseline.',
      subtitle:
          'These settings power goals, HR zones, readiness, and AI coach context. Everything here is optional and editable later.',
      children: [
        PremiumCard(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'metric', label: Text('Metric')),
                  ButtonSegment(value: 'imperial', label: Text('Imperial')),
                ],
                selected: {unitSystem},
                onSelectionChanged: (values) => onUnitChanged(values.first),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        suffixText: 'kg',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maxHrController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max HR',
                        suffixText: 'bpm',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: restingHrController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Resting HR',
                  suffixText: 'bpm',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PremiumCard(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stepsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Daily steps',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: weeklyDistanceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Weekly km',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _IntStepper(
                label: 'Active days per week',
                value: activeDays,
                min: 1,
                max: 7,
                onChanged: onActiveDaysChanged,
              ),
              const Divider(height: 24),
              _IntStepper(
                label: 'Sleep target hours',
                value: sleepHours,
                min: 4,
                max: 12,
                onChanged: onSleepHoursChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FavoriteSportsStep extends StatelessWidget {
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  const _FavoriteSportsStep({required this.selected, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final featured = sportModes
        .where((mode) => mode.defaultOnBand || mode.requiresGps)
        .take(18);
    return _StepScaffold(
      icon: Icons.directions_run_outlined,
      title: 'Pick your quick-start sports.',
      subtitle:
          'These favorites appear in the premium sport picker. The list supports Xiaomi Smart Band 9 Active modes and generic phone GPS recording.',
      children: [
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                featured
                    .map(
                      (mode) => FilterChip(
                        selected: selected.contains(mode.key),
                        label: Text(mode.name),
                        avatar: Icon(
                          mode.requiresGps
                              ? Icons.gps_fixed
                              : Icons.fitness_center,
                          size: 16,
                        ),
                        onSelected: (_) => onToggle(mode.key),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(height: 14),
        InfoPanel(
          icon: Icons.watch_outlined,
          title: 'Smartwatch compatibility',
          body:
              'If a watch or Health Connect source does not provide a sensor, that metric stays marked as not found. Xiaomi Band 9 Active remains supported for exported steps, sleep, HR, SpO2, and stress when Mi Fitness writes them.',
        ),
      ],
    );
  }
}

class _SetupRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _SetupRow({
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccentIconBox(icon: icon, color: AppTheme.cyan, size: 36),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              Text(body, style: TextStyle(color: Theme.of(context).hintColor)),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntStepper extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _IntStepper({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        IconButton(
          onPressed: value <= min ? null : () => onChanged(value - 1),
          icon: const Icon(Icons.remove_circle_outline),
        ),
        SizedBox(
          width: 36,
          child: Text(
            value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        IconButton(
          onPressed: value >= max ? null : () => onChanged(value + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}
