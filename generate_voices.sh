#!/usr/bin/env bash
#
# generate_voices.sh — create the 7 AXON narration clips with Amazon Polly.
# Output: narration/s1.mp3 … narration/s7.mp3  (next to this script)
#
# PREREQUISITES (one time):
#   1. Install the AWS CLI:        https://aws.amazon.com/cli/
#   2. Configure your credentials: aws configure
#      (the IAM user/role just needs the  polly:SynthesizeSpeech  permission)
#
# RUN:
#   cd "/Users/vipra/Documents/showcase video"
#   bash generate_voices.sh
#
# ─────────────────────────────────────────────────────────────────────────────
# VOICE / ENGINE SETTINGS — change these three lines if you want.
#
#   ENGINE: "generative" = most natural (region-limited; us-east-1 supports it).
#           If you get an "engine not supported" error, change it to "neural"
#           (neural works in every region incl. Sydney and still sounds great).
#   VOICE : "Matthew" works on BOTH generative and neural, so the fallback keeps the
#           same voice. Other good ones: Ruth, Joanna, Stephen, Danielle, Amy.
#   REGION: us-east-1 is used because it supports the generative engine. Your
#           credentials work cross-region, so you don't need to change anything
#           in your AWS account.
#
REGION="us-east-1"
ENGINE="generative"
VOICE="Matthew"
# ─────────────────────────────────────────────────────────────────────────────

set -u
cd "$(dirname "$0")"
mkdir -p narration

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI not found. Install it (https://aws.amazon.com/cli/) and run 'aws configure'."
  exit 1
fi

gen () {
  local id="$1"; local text="$2"
  printf '→ %s  (%s / %s)\n' "$id" "$ENGINE" "$VOICE"
  if ! aws polly synthesize-speech \
        --region "$REGION" \
        --engine "$ENGINE" \
        --voice-id "$VOICE" \
        --text-type text \
        --output-format mp3 \
        --text "$text" \
        "narration/$id.mp3" >/dev/null; then
    echo "   ✗ failed for $id. If this says the engine isn't supported, set ENGINE=\"neural\" at the top and re-run."
    return 1
  fi
}

# NOTE: keep these texts identical to the v: fields in SECS[] inside Showcase Final.html
gen s1 "Every day, over 2.2 billion people worldwide live with some form of visual impairment. For them, something as simple as crossing a street can be life-threatening."

gen s2 "Traditional mobility aids like white canes and guide dogs are valuable, but they have limits. They can't warn you about a cyclist approaching from behind, a car running a red light, or a wet surface up ahead. They can't read a sign, describe a scene, or answer a question about what's around you. The world is full of invisible dangers, and existing tools simply weren't designed to see them all."

gen s3 "Meet AXON. A wearable, agentic spatial assistant that gives visually impaired pedestrians a real-time AI co-pilot. Whether you're streaming video from Meta AI smart glasses, or simply using your iPhone's camera, AXON works with the devices you already own. Pair it with AirPods, and it continuously scans your surroundings, alerting you to hazards the moment they appear. No special hardware. No expensive equipment. Just intelligence, always watching, always listening."

gen s4 "At the heart of AXON is a dual-loop architecture. The first loop is always on. A passive safety system. A custom-trained YOLOv12 model runs at 25 to 40 frames per second, scanning every frame for danger. It detects 23 classes of real-world hazards. Vehicles, cyclists, potholes, bollards, construction barriers, traffic lights, and more. The moment a threat enters your path, you hear an instant spoken alert through your AirPods. No button to press. No app to open. It just works."

gen s5 "The second loop is powered by your voice. Ask AXON, What's in front of me? Or, Is it safe to cross? And it listens. Your speech is processed through Whisper, your intent is routed intelligently, and a vision-language model analyses the scene to give you a natural, spoken answer. AXON doesn't just detect. It understands. It's not a tool you use. It's a companion that sees for you."

gen s6 "Behind AXON is a dataset of over 51,000 images and nearly 172,000 bounding boxes, assembled from 39 sources and trained across multiple iterations on cloud GPUs. The result: a model achieving a mAP at 50 of 70.9 percent, a precision of 78.3 percent, and a recall of 65 percent. Every number here represents a hazard caught, a danger avoided, a safer step forward."

gen s7 "AXON was built on a single belief: that everyone deserves to move through the world with confidence and independence. By turning the devices you already carry into a real-time AI companion, it brings awareness and safety to every step you take. This isn't just assistive technology — it's a new sense of freedom. This is AXON. Intelligence you can wear. Safety you can hear."

echo ""
echo "Done. Files in ./narration/ :"
ls -1 narration/*.mp3 2>/dev/null || echo "  (none — check the error above)"
