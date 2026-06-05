# Map & Offline Tile License Decision
**Versi:** 1.0  
**Tanggal:** 2026-06-05  
**Status:** Active decision

---

## 1. Summary

Health Analyzer must support offline maps, including offline satellite in the roadmap, but the core app must remain safe for future open-source + subscription and possible Play Store distribution.

Decision:

- Remove `flutter_map_tile_caching` from the core Flutter app for now.
- Do not bulk-download public OSM/Esri/Stadia tiles in v1.
- Keep online street/satellite rendering with grey fallback when tiles fail.
- Use EOX Sentinel-2 Cloudless 2017 as the default free/open online satellite
  source because it is CC BY 4.0 with attribution.
- Use **PMTiles regional map packs** as the future offline map strategy.
- Koyeb should host only region catalog metadata and download URLs, not act as the global satellite tile server.

This is not legal advice; final public/commercial release should still receive a human license review.

---

## 2. Current License Findings

| Package / Source | Purpose | License / Note | Decision |
|------------------|---------|----------------|----------|
| `flutter_map` | Map rendering | Permissive ecosystem package | Keep |
| `flutter_map_tile_caching` | Bulk tile cache/download | GPL-v3 per pub.dev/FMTC docs | Removed from core app |
| `flutter_map_cache` | Runtime tile cache only | MIT, no bulk offline region download | Candidate for online cache |
| `flutter_map_pmtiles` | PMTiles tile provider | MIT, supports local/hosted PMTiles via HTTP range requests | Candidate for offline packs |
| OpenStreetMap public tiles | Street tiles | Public tile terms/rate limits; bulk download discouraged | Online only unless using approved provider |
| EOX Sentinel-2 Cloudless 2017 | Satellite online | CC BY 4.0 with attribution; contains modified Copernicus Sentinel data 2017 | Default free/open satellite source |
| Esri World Imagery | Satellite online | Public service terms/rate limits apply | Optional configured source |
| OpenAerialMap / Sentinel-2 | Imagery source | Coverage/resolution constraints | Candidate source for explicit PMTiles packs |

References:

- `flutter_map_tile_caching` license: https://pub.dev/packages/flutter_map_tile_caching
- FMTC install docs mention GPL-v3: https://fmtc.jaffaketchup.dev/get-started/installation
- `flutter_map_cache` license: https://pub.dev/packages/flutter_map_cache/license
- `flutter_map_pmtiles` package/license: https://pub.dev/packages/flutter_map_pmtiles
- EOX Sentinel-2 Cloudless 2017 license/source: https://tiles.maps.eox.at/wmts/1.0.0/WMTSCapabilities.xml

---

## 3. Product-Safe Offline Map Strategy

### Street Maps

v1:

- Street tiles remain online.
- Route line still renders if tiles fail.
- Offline street background waits for PMTiles or a provider with explicit offline rights.

Future:

- Add downloadable street PMTiles packs.
- Each pack includes source, license, bounds, zoom range, file size, and checksum.

### Satellite Maps

v1:

- Satellite tiles default to EOX Sentinel-2 Cloudless 2017.
- Esri, MapTiler, and custom HTTPS tile URLs remain available as optional
  configured sources.
- Offline satellite download is represented as a PMTiles pack request/metadata flow.
- App must not bulk-download public satellite tiles.

Future:

- Regional satellite PMTiles packs from licensed/open imagery sources.
- Koyeb catalog endpoint returns available packs.
- User downloads pack file to device.
- App renders local PMTiles offline.

---

## 4. Implementation State

Implemented now:

- `flutter_map_tile_caching` removed from `pubspec.yaml`.
- Default online satellite source changed to EOX Sentinel-2 Cloudless 2017
  (`s2cloudless-2017_3857`) with CC BY 4.0 attribution.
- `OfflineMapService.initialise()` is now a no-op.
- Offline region action records `planned_pmtiles` metadata instead of downloading public tiles.
- Koyeb exposes a PMTiles catalog endpoint from explicit pack metadata.
- Map Settings lists catalog packs with source, license, attribution, size, and
  bounds.
- Users can download catalog PMTiles files to app support storage.
- Downloaded packs are tracked as `ready_pmtiles`, `failed_pmtiles`, or
  `deleted`.
- `flutter_map_pmtiles` is integrated for local raster PMTiles rendering.
- `RouteMap` selects a ready local PMTiles pack when the map center is inside
  the pack bounds and the requested style matches.
- `RouteMap` renders online tiles directly and keeps grey fallback + route line.
- Map Settings explains that GPS records offline and public bulk tile download
  is disabled for license safety.

Still requires human review before public release:

- Source/license of each published PMTiles imagery pack.
- Attribution text for each pack.
- Commercial terms for any paid tile or imagery provider.

---

## 5. Acceptance Criteria For Future PMTiles Phase

- User can see available offline map packs with source/license/size.
- User can download a small regional PMTiles pack.
- App renders the PMTiles pack offline.
- If PMTiles pack is missing or corrupted, route line remains visible over grey fallback.
- No raw activity data is sent to map catalog endpoints.
- Public tile providers are not bulk-downloaded without explicit permission.

---

## 6. Release Rule

Before Play Store/public monetized release:

- Re-run dependency license audit.
- Confirm app license model.
- Confirm map provider terms.
- Confirm PMTiles imagery license and attribution.
- Document source and attribution in-app.
