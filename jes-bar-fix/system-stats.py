"""One shared JSON stream for the JES bar. Linux, standard library only."""
import json
from pathlib import Path
import time


def read_cpu(path=Path("/proc/stat")):
    fields = path.read_text().splitlines()[0].split()
    # Include user..steal, excluding guest counters already counted in user/nice.
    ticks = [int(value) for value in fields[1:9]]
    return sum(ticks), ticks[3] + ticks[4]


def cpu_percent(previous, current):
    total = current[0] - previous[0]
    idle = current[1] - previous[1]
    if total <= 0:
        return 0
    return round(max(0, min(100, 100 * (total - idle) / total)))


def read_ram(path=Path("/proc/meminfo")):
    fields = {line.split()[0].rstrip(":"): int(line.split()[1])
              for line in path.read_text().splitlines() if len(line.split()) >= 2}
    total = fields["MemTotal"]
    available = fields["MemAvailable"]
    used = max(0, total - available)
    return {"ram_used_gib": round(used / 1048576, 1),
            "ram_total_gib": round(total / 1048576, 1),
            "ram_percent": round(100 * used / total)}


def main():
    previous = read_cpu()
    print(json.dumps({"cpu_percent": None, **read_ram()}), flush=True)
    while True:
        time.sleep(2)
        current = read_cpu()
        print(json.dumps({"cpu_percent": cpu_percent(previous, current), **read_ram()}), flush=True)
        previous = current


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        pass
