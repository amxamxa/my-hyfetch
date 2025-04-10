#!/usr/bin/env bash
# name: hy-ex


# Alle Ausgaben in eine Datei
#hyfetch --help | grep -o "{.*}" | tr -d "{}" | tr ',' '\n' | while read preset; do
#  echo "${MINT} Preset-Name:     $preset"     
#    hyfetch -p $preset >> ausgabe-hyfetch.txt
# done

# Oder jeden Preset in separate Datei
# hyfetch --help | grep -o "{.*}" | tr -d "{}" | tr ',' '\n' | while read preset; do
#    hyfetch -p $preset > "preset_$preset.txt"
# done
#!/usr/bin/env bash

# Farben für Benutzerfreundlichkeit
RESET="\e[0m"
GREEN="\033[38;2;0;255;0m\033[48;2;0;25;2m"
RED="\033[38;2;240;138;100m\033[48;2;147;18;61m"
LILA="\033[38;2;85;85;255m\033[48;2;21;16;46m"

# Hilfe anzeigen
show_help() {
    echo -e "${LILA}Dieses Skript führt 'hyfetch' aus, um Preset-Informationen abzurufen.${RESET}"
    echo "Optionen:"
    echo "  -h, --help        Zeigt diese Hilfe an"
    echo "  -o, --output-dir  Verzeichnis für die Ausgabe (Standard: ./output)"
    echo "  -m, --mode        Ausgabemodus: 'single' für eine Datei, 'multiple' für separate Dateien (Standard: single)"
    echo
    echo "Beispiel:"
    echo "  ./hy-ex.sh "
    echo "  ./hy-ex.sh --output-dir ./results --mode multiple"
}

# Standardwerte für konfigurierbare Optionen
output_dir="./output"
mode="single"

# Argumente verarbeiten
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -o|--output-dir)
            output_dir="$2"
            shift
            ;;
        -m|--mode)
            mode="$2"
            shift
            ;;
        *)
            echo -e "${RED}Unbekannte Option: $1${RESET}"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Verzeichnis erstellen, falls nicht vorhanden
mkdir -p "$output_dir"

# Funktionen definieren
process_presets_single() {
    echo -e "${GREEN}Starte Verarbeitung aller Presets in eine Datei...${RESET}"
    local output_file="$output_dir/ausgabe-hyfetch.txt"
    hyfetch --help | grep -o "{.*}" | tr -d "{}" | tr ',' '\n' | while read preset; do
        echo -e "${LILA}Verarbeite Preset: $preset${RESET}"
        echo "Preset-Name: $preset" >> "$output_file"
        hyfetch -p "$preset" >> "$output_file"
    done
    echo -e "${GREEN}Ausgabe gespeichert in: $output_file${RESET}"
}

process_presets_multiple() {
    echo -e "${GREEN}Starte Verarbeitung jedes Presets in separate Dateien...${RESET}"
    hyfetch --help | grep -o "{.*}" | tr -d "{}" | tr ',' '\n' | while read preset; do
        echo -e "${LILA}Verarbeite Preset: $preset${RESET}"
        local output_file="$output_dir/preset_$preset.txt"
        hyfetch -p "$preset" > "$output_file"
        echo -e "${GREEN}Ausgabe für $preset gespeichert in: $output_file${RESET}"
    done
}

# Hauptlogik basierend auf dem Modus
if [[ "$mode" == "single" ]]; then
    process_presets_single
elif [[ "$mode" == "multiple" ]]; then
    process_presets_multiple
else
    echo -e "${RED}Ungültiger Modus: $mode${RESET}"
    show_help
    exit 1
fi
