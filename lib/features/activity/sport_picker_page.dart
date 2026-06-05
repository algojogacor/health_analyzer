import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/sport_mode.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/premium_card.dart';

class SportPickerPage extends StatefulWidget {
  final SportMode selectedMode;

  const SportPickerPage({super.key, required this.selectedMode});

  @override
  State<SportPickerPage> createState() => _SportPickerPageState();
}

class _SportPickerPageState extends State<SportPickerPage> {
  static const _favoriteKey = 'sport_picker.favorites';
  static const _recentKey = 'sport_picker.recent';
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final _queryController = TextEditingController();
  final _favorites = <String>{};
  final _recent = <String>[];
  String _query = '';
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered =
        sportModes
            .where(
              (mode) =>
                  _query.trim().isEmpty ||
                  mode.name.toLowerCase().contains(_query.toLowerCase()) ||
                  mode.category.toLowerCase().contains(_query.toLowerCase()),
            )
            .toList();
    final grouped = <String, List<SportMode>>{};
    for (final mode in filtered) {
      grouped.putIfAbsent(mode.category, () => []).add(mode);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose sport')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          TextField(
            controller: _queryController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: 'Search sport mode',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.line),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.line),
              ),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          if (_loaded && _recent.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ModeStrip(
              title: 'Recent',
              modes: _recent.map(sportModeByKey).toList(),
              selectedKey: widget.selectedMode.key,
              favorites: _favorites,
              onPick: _pick,
              onToggleFavorite: _toggleFavorite,
            ),
          ],
          if (_loaded && _favorites.isNotEmpty) ...[
            const SizedBox(height: 16),
            _ModeStrip(
              title: 'Favorites',
              modes: _favorites.map(sportModeByKey).toList(),
              selectedKey: widget.selectedMode.key,
              favorites: _favorites,
              onPick: _pick,
              onToggleFavorite: _toggleFavorite,
            ),
          ],
          const SizedBox(height: 16),
          ...grouped.entries.map(
            (entry) => _ModeSection(
              title: entry.key,
              modes: entry.value,
              selectedKey: widget.selectedMode.key,
              favorites: _favorites,
              onPick: _pick,
              onToggleFavorite: _toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _load() async {
    final favorites = await _storage.read(key: _favoriteKey);
    final recent = await _storage.read(key: _recentKey);
    if (!mounted) return;
    setState(() {
      _favorites
        ..clear()
        ..addAll(_parseKeys(favorites));
      _recent
        ..clear()
        ..addAll(_parseKeys(recent));
      _loaded = true;
    });
  }

  Future<void> _pick(SportMode mode) async {
    final recent =
        [mode.key, ..._recent.where((key) => key != mode.key)].take(6).toList();
    await _storage.write(key: _recentKey, value: recent.join(','));
    if (!mounted) return;
    Navigator.of(context).pop(mode);
  }

  Future<void> _toggleFavorite(SportMode mode) async {
    setState(() {
      if (_favorites.contains(mode.key)) {
        _favorites.remove(mode.key);
      } else {
        _favorites.add(mode.key);
      }
    });
    await _storage.write(key: _favoriteKey, value: _favorites.join(','));
  }

  List<String> _parseKeys(String? raw) {
    final valid = sportModes.map((mode) => mode.key).toSet();
    if (raw == null || raw.trim().isEmpty) return const [];
    return raw.split(',').where(valid.contains).toList();
  }
}

class _ModeStrip extends StatelessWidget {
  final String title;
  final List<SportMode> modes;
  final String selectedKey;
  final Set<String> favorites;
  final ValueChanged<SportMode> onPick;
  final ValueChanged<SportMode> onToggleFavorite;

  const _ModeStrip({
    required this.title,
    required this.modes,
    required this.selectedKey,
    required this.favorites,
    required this.onPick,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        SizedBox(
          height: 96,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: modes.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder:
                (_, index) => SizedBox(
                  width: 180,
                  child: _ModeTile(
                    mode: modes[index],
                    selected: modes[index].key == selectedKey,
                    favorite: favorites.contains(modes[index].key),
                    onPick: onPick,
                    onToggleFavorite: onToggleFavorite,
                  ),
                ),
          ),
        ),
      ],
    );
  }
}

class _ModeSection extends StatelessWidget {
  final String title;
  final List<SportMode> modes;
  final String selectedKey;
  final Set<String> favorites;
  final ValueChanged<SportMode> onPick;
  final ValueChanged<SportMode> onToggleFavorite;

  const _ModeSection({
    required this.title,
    required this.modes,
    required this.selectedKey,
    required this.favorites,
    required this.onPick,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          ...modes.map(
            (mode) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ModeTile(
                mode: mode,
                selected: mode.key == selectedKey,
                favorite: favorites.contains(mode.key),
                onPick: onPick,
                onToggleFavorite: onToggleFavorite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  final SportMode mode;
  final bool selected;
  final bool favorite;
  final ValueChanged<SportMode> onPick;
  final ValueChanged<SportMode> onToggleFavorite;

  const _ModeTile({
    required this.mode,
    required this.selected,
    required this.favorite,
    required this.onPick,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      onTap: () => onPick(mode),
      padding: const EdgeInsets.all(12),
      color: selected ? AppTheme.cyan.withValues(alpha: 0.08) : Colors.white,
      borderColor: selected ? AppTheme.cyan : AppTheme.line,
      child: Row(
        children: [
          AccentIconBox(
            icon:
                mode.requiresGps
                    ? Icons.explore_outlined
                    : Icons.fitness_center,
            color: mode.requiresGps ? AppTheme.cyan : AppTheme.coral,
            size: 38,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mode.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _Badge(mode.requiresGps ? 'GPS' : 'Indoor'),
                    if (mode.defaultOnBand) const _Badge('Band default'),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => onToggleFavorite(mode),
            icon: Icon(favorite ? Icons.star : Icons.star_border),
            color: favorite ? AppTheme.amber : AppTheme.muted,
            tooltip: favorite ? 'Remove favorite' : 'Add favorite',
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;

  const _Badge(this.label);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppTheme.canvas,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: TextStyle(
            color: AppTheme.muted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
