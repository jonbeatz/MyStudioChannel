# 🗣️ Hermes Agent — On-Demand Voice Commands (Windows 11)

This guide covers how to utilize **Hermes Agent** with **on-demand voice** on Windows 11, enabling Hermes to speak only when explicitly requested rather than automatically on every single response.

Voice-on-demand is powered directly by the **Windows Native Text-to-Speech (TTS)** engine (`System.Speech`), bypassing Edge TTS streaming overhead. This provides instant, ultra-low latency, and reliable audio playbacks while keeping you in complete control.

---

## 1. ⚙️ Quick Setup (One-Time)

To register the custom, high-speed `speak` utility, append the wrapper function directly to your active PowerShell profile.

### Step-by-Step Profile Configuration:
Run the following command in an active PowerShell terminal to inject the function:

```powershell
Add-Content $PROFILE @'
function speak {
    $response = hermes -z $args
    Add-Type -AssemblyName System.Speech
    $speech = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $speech.Speak($response)
    Write-Host $response
}
'@
```

### Reload Shell:
After executing the setup snippet, reload your terminal by restarting Cursor or running a fresh PowerShell window.

---

## 2. 📋 Usage & Commands

| Command | Execution Mode | Audio Output | Text Output |
| :--- | :--- | :--- | :--- |
| `speak "your question here"` | On-Demand | 🔊 **Enabled** (Out Loud) | 💻 **Visible** |
| `hermes -z "your question"` | Standard | 🔇 Disabled | 💻 **Visible** |
| `hermes` | Interactive TUI | 🔇 Disabled (unless toggled) | 💻 **Visible** |

---

## 3. 💡 Audio Examples & Recipes

Test the on-demand speech capability with these highly practical engineering templates:

```powershell
# Explain local studio settings
speak "What is the MSC PRO ENGINE?"

# Perform local git audits
speak "Review my latest git commit"

# Dev humor break
speak "Tell me a quick joke about programming"

# Fast terminal error diagnosis
speak "Explain this error: [paste your error]"

# Quick devops checklist
speak "What are the deployment commands for this project?"
```

---

## 4. 🔗 One-Liner (No Profile Setup Required)

If you are on a temporary terminal session or have not loaded your PowerShell profile, execute this single line to summon Hermes with audio playbacks immediately:

```powershell
$r = hermes -z "your question here"; Add-Type -AssemblyName System.Speech; $s = New-Object System.Speech.Synthesis.SpeechSynthesizer; $s.Speak($r); $r
```

---

## 🎛️ 5. Interactive Voice Controls

While in interactive terminal user interface (TUI) chat modes, voice parameters are easily toggled with slash commands:

*   **To Enable Voice in Live Chat:** Type `/voice tts` inside Hermes.
*   **To Disable Voice in Live Chat:** Type `/voice off` inside Hermes.

---

## 🩺 6. Troubleshooting

### ❌ No Voice When Executing `speak`
*   **Verification:** Check if the speak function is registered on your system:
    ```powershell
    Get-Command speak
    ```
*   **Terminal Reset:** Ensure you fully restarted your active PowerShell session after appending variables to your `$PROFILE`.
*   **Direct Windows Test:** Isolate and test the native Windows speech engine:
    ```powershell
    Add-Type -AssemblyName System.Speech
    $s = New-Object System.Speech.Synthesis.SpeechSynthesizer
    $s.Speak("Vader is Online")
    ```

### ❌ `speak` command not found
**Cause:** The script wrapper was not appended to the correct active profile location on your machine.
**Solution:** Run the **Quick Setup** command again, and then reload the terminal context.

### 🔊 Voice Speed is Too Fast or Slow
**Solution:** Adjust the Speech Rate parameter within your `$PROFILE` speak script block (supports a range from `-10` to `10`, with a default of `0`):

```powershell
# Inside speak function, set rate before trigger:
$speech.Rate = 1  # Standard fast-pace reading
```

---

## 📂 7. Core Files & Locations

| Resource | Path |
| :--- | :--- |
| **PowerShell Profile** | `notepad $PROFILE` |
| **Global Config File** | `C:\Users\JONBEATZ\AppData\Local\hermes\config.yaml` |
| **Project Context Map** | `D:\Cursor_Projectz\MyStudioChannel\HERMES.md` |

---

## ℹ️ 8. Version & OS Matrix

*   **CLI Engine:** Hermes Agent `v0.16.0` (Upstream build)
*   **OS Environment:** Native Windows 11 (PowerShell Core / Desktop)
*   **Audio Driver:** Windows Native `System.Speech` Synthesizer Engine
