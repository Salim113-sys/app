# Image Specifications for Daily Reset App

This document outlines the requirements for all image assets in the application. Since automatic generation was limited by quota, these specifications should be used to generate or create the assets manually using tools like Gemini, Ideogram, or Midjourney.

**General Style Guide:**

- **Vibe:** Premium, Wellness, Calm, Minimalist.
- **Colors:** Soft pastels (Teal #4ECDC4, Coral #FF6B6B) mixed with warm neutrals.
- **Style:** Flat vector illustrations OR high-quality 3D minimalist icons. Consistent across all categories.
- **Format:** PNG (transparent background where applicable).

---

## 1. Program Hero Images

**Usage:** Displayed at the top of the `WorkoutRoutineDetailScreen`.
**Dimensions:** 1600 x 900 px (16:9 aspect ratio).
**Placement:** `assets/programs/`

| Filename | Concept / Prompt Idea |
| :--- | :--- |
| `quick_full_body_hero.png` | A balanced composition showing a yoga mat, dumbbells, and a water bottle in gentle sunlight. |
| `mobility_reset_hero.png` | Abstract flowing lines or a character stretching gently, conveying flexibility and relief. |
| `cardio_boost_hero.png` | Dynamic but soft shapes, running shoes, or a stopwatch with motion lines. |
| `evening_unwind_hero.png` | A cozy evening setting, perhaps a candle, a book, and soft moon lighting. |
| `strength_focus_hero.png` | Minimalist representation of weights or a strong geometric composition. |

---

## 2. Exercise Illustrations

**Usage:** Displayed in `WorkoutSessionScreen` (large) and `WorkoutRoutineDetailScreen` (thumbnail).
**Dimensions:** 800 x 600 px (4:3 aspect ratio).
**Placement:** `assets/exercises/`
**Style:** Clear, instructional, but aesthetically pleasing. Avoid cluttered backgrounds.

| Filename | Description / Prompt |
| :--- | :--- |
| `warm_up_march.png` | Character marching in place, knees high, happy expression. |
| `bodyweight_squats.png` | Character performing a perfect squat form. |
| `incline_pushups.png` | Character doing pushups against a minimal wall or surface. |
| `reverse_lunges.png` | Character stepping back into a lunge. |
| `plank_hold.png` | Character in a solid plank position, flat back. |
| `neck_rolls.png` | Close up of head/neck area showing gentle rotation arrows. |
| `cat_cow.png` | Side view of character on all fours, arching back. |
| `thoracic_rotations.png` | Character rotating upper body, opening chest. |
| `hip_circles.png` | Character with hands on hips performing circular motion. |
| `childs_pose.png` | Character resting in child's pose, very peaceful. |
| `march_in_place.png` | Similar to warm up march, maybe more energetic. |
| `step_jacks.png` | Character stepping side to side, arms raising. |
| `high_knees.png` | Dynamic pose, driving knees up. |
| `rest.png` | Icon of a pause button or a person breathing/relaxing. |
| `fast_feet.png` | Blur effect on feet showing quick tapping motion. |
| `butt_kicks.png` | Jogging in place, heels touching glutes. |
| `neck_stretch.png` | Hand gently guiding head to shoulder. |
| `shoulder_rolls.png` | Arrows indicating circular motion of shoulders. |
| `seated_forward_fold.png` | Character sitting, reaching towards toes. |
| `figure4_stretch.png` | Character lying on back, legs figure-4 shape. |
| `deep_breathing.png` | Abstract representation of breath/lungs or character meditating. |
| `standard_pushups.png` | Standard pushup on the floor. |
| `alternating_lunges.png` | Forward lunging motion. |
| `glute_bridges.png` | Character lying on back, hips lifted high. |
| `dead_bug.png` | Character on back, opposite arm/leg extended. |
| `wall_sit.png` | Character sitting against an invisible wall (or minimal line). |

---

## 3. Onboarding Visuals

**Usage:** Full screen width in `OnboardingScreen`. adapt to height via `Expanded`.
**Dimensions:** 1000 x 1000 px (Square) or 800 x 1000 px (4:5). Using **BoxFit.cover**.
**Placement:** `assets/onboarding/`

| Filename | Scene Description |
| :--- | :--- |
| `welcome_1.png` | **"Track Tiny Habits"**: A visual checklist with checkboxes turning into leaves/flowers. Growth metaphor. |
| `welcome_2.png` | **"Log Your Mood Daily"**: A calendar with diverse smiley faces (happy, calm, neutral) in soft colors. |
| `welcome_3.png` | **"See Your Progress"**: A stylized graph going up, with a trophy or star at the top. |

---

## 4. Badges (Gamification)

**Usage:** `TodayOverviewCard` and future profile stats.
**Dimensions:** 512 x 512 px.
**Placement:** `assets/badges/`
**Technical:** Transparent background is CRITICAL.

| Filename | Description |
| :--- | :--- |
| `bronze.png` | Bronze medal or shield, minimalist matte finish. |
| `silver.png` | Silver medal or shield, clean metallic look. |
| `gold.png` | Gold medal or shield, shining effect. |
| `platinum.png` | Platinum/Diamond look, iridescent or glowing blue-white. |

---

## 5. Hydration

**Note:** The app currently uses a **Programmatic 3D Glass** (`HydrationGlass` widget) rendered with Flutter CustomPainters and Container properties.
**No specific image assets are required** for the current implementation.
If transitioning to images in the future, recommended:

- `assets/hydration/glass_empty.png`
- `assets/hydration/glass_half.png`
- `assets/hydration/glass_full.png`
(Dimensions: 512x800 px, Transparent BG)
