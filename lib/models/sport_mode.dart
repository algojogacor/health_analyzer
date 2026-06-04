class SportMode {
  final String key;
  final String name;
  final String category;
  final bool requiresGps;
  final bool defaultOnBand;
  final double stopSpeedMps;
  final double resumeSpeedMps;
  final int minStopSeconds;
  final double accuracyFilterMeters;

  const SportMode({
    required this.key,
    required this.name,
    required this.category,
    required this.requiresGps,
    required this.defaultOnBand,
    required this.stopSpeedMps,
    required this.resumeSpeedMps,
    required this.minStopSeconds,
    required this.accuracyFilterMeters,
  });
}

const _walk = (
  stopSpeedMps: 0.83,
  resumeSpeedMps: 1.2,
  minStopSeconds: 20,
  accuracyFilterMeters: 50.0,
);
const _run = (
  stopSpeedMps: 1.4,
  resumeSpeedMps: 1.8,
  minStopSeconds: 25,
  accuracyFilterMeters: 50.0,
);
const _cycle = (
  stopSpeedMps: 0.5,
  resumeSpeedMps: 1.2,
  minStopSeconds: 35,
  accuracyFilterMeters: 35.0,
);
const _hike = (
  stopSpeedMps: 0.56,
  resumeSpeedMps: 1.0,
  minStopSeconds: 45,
  accuracyFilterMeters: 60.0,
);
const _generic = (
  stopSpeedMps: 0.5,
  resumeSpeedMps: 1.0,
  minStopSeconds: 30,
  accuracyFilterMeters: 50.0,
);

SportMode _mode(
  String key,
  String name,
  String category, {
  bool requiresGps = false,
  bool defaultOnBand = false,
  ({
        double stopSpeedMps,
        double resumeSpeedMps,
        int minStopSeconds,
        double accuracyFilterMeters,
      })
      config =
      _generic,
}) {
  return SportMode(
    key: key,
    name: name,
    category: category,
    requiresGps: requiresGps,
    defaultOnBand: defaultOnBand,
    stopSpeedMps: config.stopSpeedMps,
    resumeSpeedMps: config.resumeSpeedMps,
    minStopSeconds: config.minStopSeconds,
    accuracyFilterMeters: config.accuracyFilterMeters,
  );
}

final sportModes = <SportMode>[
  _mode(
    'outdoor_running',
    'Outdoor running',
    'Outdoor Workouts',
    requiresGps: true,
    defaultOnBand: true,
    config: _run,
  ),
  _mode(
    'walking',
    'Walking',
    'Outdoor Workouts',
    requiresGps: true,
    defaultOnBand: true,
    config: _walk,
  ),
  _mode(
    'hiking',
    'Hiking',
    'Outdoor Workouts',
    requiresGps: true,
    defaultOnBand: true,
    config: _hike,
  ),
  _mode(
    'outdoor_cycling',
    'Outdoor cycling',
    'Outdoor Workouts',
    requiresGps: true,
    defaultOnBand: true,
    config: _cycle,
  ),
  _mode(
    'mountaineering',
    'Mountaineering',
    'Outdoor Workouts',
    requiresGps: true,
    defaultOnBand: true,
    config: _hike,
  ),
  _mode(
    'cross_country_running',
    'Cross country running',
    'Outdoor Workouts',
    requiresGps: true,
    config: _run,
  ),
  _mode('skateboard', 'Skateboard', 'Outdoor Workouts', requiresGps: true),
  _mode(
    'roller_skating',
    'Roller skating',
    'Outdoor Workouts',
    requiresGps: true,
  ),
  _mode('free_activities', 'Free activities', 'Training', defaultOnBand: true),
  _mode(
    'indoor_running',
    'Indoor running',
    'Training',
    defaultOnBand: true,
    config: _run,
  ),
  _mode('rope_jumping', 'Rope jumping', 'Training', defaultOnBand: true),
  _mode('hiit', 'High-intensity interval training', 'Training'),
  _mode('yoga', 'Yoga', 'Training'),
  _mode('indoor_cycling', 'Indoor cycling', 'Training', config: _cycle),
  _mode('elliptical_machine', 'Elliptical machine', 'Training'),
  _mode('rowing_machine', 'Rowing machine', 'Training'),
  _mode('core_training', 'Core training', 'Training'),
  _mode('flexibility_training', 'Flexibility training', 'Training'),
  _mode('pilates', 'Pilates', 'Training'),
  _mode('stretch', 'Stretch', 'Training'),
  _mode('strength_training', 'Strength training', 'Training'),
  _mode('stair_climbing', 'Stair climbing', 'Training'),
  _mode('aerobics', 'Aerobics', 'Training'),
  _mode('dumbbell_training', 'Dumbbell training', 'Training'),
  _mode('barbell_training', 'Barbell training', 'Training'),
  _mode('weightlifting', 'Weightlifting', 'Training'),
  _mode('burpees', 'Burpees', 'Training'),
  _mode('sit_ups', 'Sit-ups', 'Training'),
  _mode('waist_abdomen_training', 'Waist and abdomen training', 'Training'),
  _mode('back_training', 'Back training', 'Training'),
  _mode('indoor_fitness', 'Indoor fitness', 'Training'),
  _mode('tennis', 'Tennis', 'Ball Games'),
  _mode('basketball', 'Basketball', 'Ball Games'),
  _mode('golf', 'Golf', 'Ball Games', requiresGps: true, config: _walk),
  _mode('football', 'Football', 'Ball Games', requiresGps: true, config: _run),
  _mode('volleyball', 'Volleyball', 'Ball Games'),
  _mode('baseball', 'Baseball', 'Ball Games'),
  _mode('rugby', 'Rugby', 'Ball Games', requiresGps: true, config: _run),
  _mode('table_tennis', 'Table tennis', 'Ball Games'),
  _mode('badminton', 'Badminton', 'Ball Games'),
  _mode('cricket', 'Cricket', 'Ball Games'),
  _mode('bowling', 'Bowling', 'Ball Games'),
  _mode('billiards', 'Billiards', 'Ball Games'),
  _mode(
    'snowboarding',
    'Snowboarding',
    'Ice and Snow Workouts',
    requiresGps: true,
  ),
  _mode('skiing', 'Skiing', 'Ice and Snow Workouts', requiresGps: true),
  _mode(
    'outdoor_skating',
    'Outdoor skating',
    'Ice and Snow Workouts',
    requiresGps: true,
  ),
  _mode('ice_hockey', 'Ice hockey', 'Ice and Snow Workouts'),
  _mode('archery', 'Archery', 'Recreational Workouts'),
  _mode('tug_of_war', 'Tug of War', 'Recreational Workouts'),
  _mode(
    'frisbee',
    'Frisbee',
    'Recreational Workouts',
    requiresGps: true,
    config: _run,
  ),
];

SportMode sportModeByKey(String key) {
  return sportModes.firstWhere(
    (mode) => mode.key == key,
    orElse: () => sportModes.first,
  );
}
