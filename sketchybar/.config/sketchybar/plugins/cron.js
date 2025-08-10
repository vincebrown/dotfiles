#!/Users/vince.brown/.local/share/mise/installs/node/23.11.0/bin/node

// Notion Calendar
import { createReadStream, rmSync } from "fs";
import { createInterface } from "readline";
import { execSync } from "child_process";

const ITEM_NAME = "cron";

const execute = (COMMAND) =>
  execSync(COMMAND, (error) => {
    if (error) {
      console.error(`exec error: ${error}`);
      return;
    }
  });

const JSON_FILE = "cron_data.json";

rmSync(JSON_FILE, { force: true });

const INDEXDB_LOCATION =
  process.env.HOME + "/Library/Application Support/Notion Calendar/IndexedDB";

const formatDuration = (time) => {
  let duration = time;
  if (duration > 60 * 60) {
    duration = Math.floor(duration / 60 / 60);
    duration =
      duration + "h " + Math.floor((time - duration * 60 * 60) / 60) + "m";
  } else if (duration > 120) {
    duration = Math.floor(duration / 60) + "m";
  } else {
    duration = "now";
  }

  return duration;
};

const truncateText = (text, length) => {
  if (text.length <= length) {
    return text;
  }

  return text.substr(0, length) + "\u2026";
};

// Set Status to Loading
execute(`
  sketchybar --set ${ITEM_NAME} \
    icon= \
    click_script="" \
`);

// Extract data from IndexedDB
const python = execute("python3 -m site --user-base").toString().trim();

// Have to use absolute path to the install since by default it will try using the python installed globally and not by mise
// For this to work you must have python installed via mise
execute(`
  ${process.env.HOME}/.local/bin/dfindexeddb db \
    -s "${INDEXDB_LOCATION}/https_calendar.notion.so_0.indexeddb.leveldb" \
    --format chrome \
    --use_manifest \
    -o jsonl \
    >> ${JSON_FILE}
`);

var rd = createInterface({
  input: createReadStream(JSON_FILE),
  console: false,
});

const events = [];

rd.on("line", function (line) {
  const data = JSON.parse(line);

  if (data.value?.value?.kind === "calendar#event") {
    const summary = data.value.value?.summary;

    let startTime = data.value.value?.start?.dateTime;
    let endTime = data.value.value?.end?.dateTime;

    // Don't process full day events
    if (!startTime) {
      return;
    }

    const isStaleData = Boolean(data.recovered);

    const timeGap = (new Date(startTime) - new Date()) / 1000;

    const isToStart = new Date() < new Date(startTime);

    const isCurrentlyOnGoing =
      new Date() > new Date(startTime) && new Date() < new Date(endTime);

    const isCancelled = data.value.value.status === "cancelled";

    const isWithin3Hours = timeGap < 60 * 60 * 3;

    const attendees = data.value.value.attendees?.values || [];

    const iAmAttending = attendees.some((attendee) => {
      return attendee.self && attendee.responseStatus !== "declined";
    });

    if (
      // The data is not stale
      !isStaleData &&
      // It is within 3 hours from now
      isWithin3Hours &&
      // The meeting is not cancelled
      !isCancelled &&
      // Meeting is to start or is ongoing
      (isToStart || isCurrentlyOnGoing) &&
      // I am attending the meeting
      iAmAttending
    ) {
      // Duration by difference of START and END
      const duration = (new Date(endTime) - new Date(startTime)) / 1000;

      events.push({
        summary,
        startTime,
        endTime,
        duration,
        meet: data.value.value.hangoutLink,
      });
    }
  }
});

rd.on("close", function () {
  // Set status to No Meetings if there are no meetings
  if (!events.length) {
    execute(`
      sketchybar --set ${ITEM_NAME} \
        label="No upcoming meetings" \
        label.padding_right=0 \
        icon=󰢠 \
        click_script="" \
        background.corner_radius=5 \
        background.height=20 \
        background.color="0x66313244" \
        icon.padding_left=8 \
        label.padding_right=8
    `);

    return;
  }

  // Get latest meeting
  const meeting = events.sort((a, b) => {
    return new Date(a.startTime) - new Date(b.startTime);
  })[0];

  const timeGap = formatDuration(
    (new Date(meeting.startTime) - new Date()) / 1000,
  );

  const duration = formatDuration(meeting.duration);

  // If meeting is too short doesn't show duration
  const durationText = duration === "now" ? "" : ` (${duration})`;

  const summary = truncateText(meeting.summary, 15);
  const remainingTime = timeGap === "now" ? "" : ` in ${timeGap}`;

  const label = `${summary}${durationText}${remainingTime}`;

  const icon = meeting.meet ? "" : "󱔠";
  const clickScript = meeting.meet ? `open -n "${meeting.meet}"` : "";

  execute(`
    sketchybar --set ${ITEM_NAME} \
      background.drawing=on \
      icon.padding_left=12 \
      label.padding_right=12 \
      label="${label}" \
      click_script="${clickScript}" \
      icon="${icon}"
  `);
});
