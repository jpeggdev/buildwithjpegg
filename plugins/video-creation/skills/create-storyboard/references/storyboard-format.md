# Storyboard Format Specification

## File Structure

```markdown
# [Project Title] - Storyboard

## Project Info

- **Total Duration**: [X] seconds
- **Aspect Ratio**: [16:9 | 9:16 | 1:1 | 4:3 | 3:4 | 21:9]
- **Visual Style**: [description of overall aesthetic]
- **Color Palette**: [dominant colors / mood]
- **Audio Direction**: [music genre, voiceover, sfx notes]
- **Target Model**: [suggested video model, e.g., seedance-2.0]

---

## Shot 1 (0:00 - 0:03)

- **Camera**: [shot type + movement]
- **Scene**: [what is visible in frame]
- **Action**: [what happens]
- **Sound**: [audio for this segment]
- **Image Prompt**: [detailed prompt for keyframe generation]

---

## Shot 2 (0:03 - 0:07)

- **Camera**: [shot type + movement]
- **Scene**: [what is visible in frame]
- **Action**: [what happens]
- **Sound**: [audio for this segment]
- **Image Prompt**: [detailed prompt for keyframe generation]

---

(continue for all shots)

---

## Notes

[Any additional production notes, references, or constraints]
```

## Field Guidelines

### Project Info

| Field | Required | Notes |
|-|-|-|
| Total Duration | Yes | Sum of all shot durations. Most models support 4-15s per clip. |
| Aspect Ratio | Yes | Must match intended video output. Common: 16:9 (landscape), 9:16 (portrait/mobile). |
| Visual Style | Yes | Describe the overall look: "cinematic noir", "bright flat illustration", "photorealistic nature documentary". |
| Color Palette | No | Helps maintain consistency. E.g., "warm golden tones", "desaturated blue-gray". |
| Audio Direction | No | High-level audio guidance for the full video. |
| Target Model | No | Suggest a video model based on requirements. |

### Shot Fields

| Field | Required | Notes |
|-|-|-|
| Camera | Yes | Use standard terminology from shot-types.md. |
| Scene | Yes | Describe the visual composition. What does the viewer see? |
| Action | Yes | Describe movement and change. What happens in this time window? |
| Sound | No | Segment-specific audio. Omit if covered by project-level audio direction. |
| Image Prompt | Yes | Self-contained prompt for keyframe generation. Must include style, subject, composition, lighting. |

### Image Prompt Best Practices

Each image prompt must be **self-contained** -- an image generation model receiving only this prompt should produce a usable keyframe. Include:

1. **Subject**: Who/what is in the frame
2. **Setting**: Where the scene takes place
3. **Composition**: Camera angle, framing, depth of field
4. **Style**: Art style, rendering quality (e.g., "photorealistic", "watercolor illustration")
5. **Lighting**: Light source, mood, color temperature
6. **Details**: Key props, clothing, expressions, textures

**Example image prompt:**
> A lone astronaut standing on a rust-colored Martian plain, facing away from camera toward a distant mountain range. Wide shot, low angle. Photorealistic, cinematic lighting with warm sunset glow from the left. Dusty atmosphere, subtle lens flare. The astronaut wears a white EVA suit with blue accents, helmet visor reflecting the orange sky.

### Duration Guidelines by Model

| Model | Min | Max | Sweet Spot |
|-|-|-|-|
| Seedance 2.0 | 4s | 15s | 5-8s |
| Sora 2 | 4s | 12s | 4-8s |
| WAN 2.6 | 3s | 10s | 4-6s |
| Hailuo 2.3 | 4s | 10s | 5s |
| VIDU Q3 | 4s | 8s | 4-6s |
