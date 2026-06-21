1|function Invoke-HermesTTS {
2|    param([string]$text)
3|    if ($text.Trim()) {
4|        & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe" -c "
5|import sys, json, logging, subprocess
6|logging.getLogger('tools.tts_tool').setLevel(logging.ERROR)
7|logging.getLogger('tools.voice_mode').setLevel(logging.ERROR)
8|sys.path.append(r'C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent')
9|from tools.tts_tool import text_to_speech_tool
10|from tools.voice_mode import play_audio_file
11|
12|text = sys.argv[1]
13|try:
14|    res = json.loads(text_to_speech_tool(text))
15|    if res.get('success'):
16|        play_audio_file(res['file_path'])
17|    else:
18|        # If primary (Gemini/Orus) fails, automatically fall back to Sonia (Edge TTS)!
19|        # We print a clean diagnostic, switch to Sonia (Edge), speak, and restore Orus.
20|        print('🎙️ Gemini/Orus API limit hit. Seamlessly falling back to Sonia (Edge TTS)...', file=sys.stderr)
21|        
22|        # 1. Switch config to Sonia (Edge)
23|        subprocess.run(['hermes', 'config', 'set', 'tts.provider', 'edge'], stdout=subprocess.DEVNULL)
24|        subprocess.run(['hermes', 'config', 'set', 'tts.edge.voice', 'en-GB-SoniaNeural'], stdout=subprocess.DEVNULL)
25|        
26|        # 2. Retry generation with the free fallback
27|        res_fallback = json.loads(text_to_speech_tool(text))
28|        if res_fallback.get('success'):
29|            play_audio_file(res_fallback['file_path'])
30|            
31|        # 3. Restore config to Orus (Gemini)
32|        subprocess.run(['hermes', 'config', 'set', 'tts.provider', 'gemini'], stdout=subprocess.DEVNULL)
33|        subprocess.run(['hermes', 'config', 'set', 'tts.gemini.voice', 'Orus'], stdout=subprocess.DEVNULL)
34|except Exception as e:
35|    print('Error:', e, file=sys.stderr)
36|" $text 2>$null
37|    }
38|}
39|
40|function test-voice {
41|    $text = $args -join " "
42|    Invoke-HermesTTS $text
43|}
44|
45|function speak {
46|    $text = $args -join " "
47|    if (-not $text.Trim()) { return }
48|    
49|    # 1. Detect if the user wants to trigger our intelligent image generation pipeline
50|    $isImageTrigger = $text -match '^\s*(make|generate|draw|paint|create)\b.*\b(image|photo|background|picture|logo|art|rendering|canvas)\b'
51|    
52|    if ($isImageTrigger) {
53|        # Extract prompt by stripping standard prefixes
54|        $cleanPrompt = $text -replace '^\s*(make|generate|draw|paint|create)\s+(me\s+)?(an?\s+)?(hd\s+)?(widescreen\s+)?(image|photo|background|picture|logo|art|rendering|painting|canvas)\s+(of\s+)?', ''
55|        
56|        # If the prompt ends with "widescreen" or "hd", strip those too
57|        $cleanPrompt = $cleanPrompt -replace '\b(in\s+)?(hd|widescreen|1920x1080|16:9|landscape)\b', ''
58|        $cleanPrompt = $cleanPrompt.Trim()
59|        
60|        # Invoke our new gen-image function and let it handle size parsing!
61|        gen-image -prompt $cleanPrompt
62|        return
63|    }
64|
65|    # 2. Detect if the input is an AI query ONLY if it starts with an AI question or instruction/action word
66|    $isAIQuery = $text -match '^\s*(how|what|why|who|where|when|can|could|should|would|will|is|are|do|does|did|tell|explain|write|create|analyze|review|suggest|check|run|test|get)\b'
67|    
68|    if ($isAIQuery) {
69|        # Touch VRAM Activity timestamp for AI reasoning tasks
70|        Update-VramActivity
71|        
72|        # Ensure a model is loaded for any local inference
73|        Ensure-ModelLoaded
74|        
75|        # Execute oneshot query with Hermes, display response, and speak it out loud
76|        $response = hermes -z $text
77|        Write-Host $response
78|        $cleanResponse = $response -join "`n"
79|        Invoke-HermesTTS $cleanResponse
80|    } else {
81|        # Directly speak the plain text without calling the LLM
82|        Invoke-HermesTTS $text
83|    }
84|}
85|
86|# --- Edge TTS Voice Shortcuts ---
87|function set-voice-andrew {
88|    hermes config set tts.provider edge | Out-Null
89|    hermes config set tts.edge.voice en-US-AndrewMultilingualNeural | Out-Null
90|    Invoke-HermesTTS "Andrew is active."
91|    Write-Host "🎙️ Default voice set to Andrew (en-US-AndrewMultilingualNeural)" -ForegroundColor Cyan
92|}
93|
94|function set-voice-sonia {
95|    hermes config set tts.provider edge | Out-Null
96|    hermes config set tts.edge.voice en-GB-SoniaNeural | Out-Null
97|    Invoke-HermesTTS "Sonia is active."
98|    Write-Host "🎙️ Default voice set to Sonia (en-GB-SoniaNeural)" -ForegroundColor Cyan
99|}
100|
101|function set-voice-ryan {
102|    hermes config set tts.provider edge | Out-Null
103|    hermes config set tts.edge.voice en-GB-RyanNeural | Out-Null
104|    Invoke-HermesTTS "Ryan is active."
105|    Write-Host "🎙️ Default voice set to Ryan (en-GB-RyanNeural)" -ForegroundColor Cyan
106|}
107|
108|# --- Gemini TTS Voice Shortcuts ---
109|function set-voice-orus {
110|    hermes config set tts.provider gemini | Out-Null
111|    hermes config set tts.gemini.voice Orus | Out-Null
112|    Invoke-HermesTTS "Orus is active."
113|    Write-Host "🎙️ Default voice set to Orus (Gemini - Orus)" -ForegroundColor Cyan
114|}
115|
116|function set-voice-charon {
117|    hermes config set tts.provider gemini | Out-Null
118|    hermes config set tts.gemini.voice Charon | Out-Null
119|    Invoke-HermesTTS "Charon is active."
120|    Write-Host "🎙️ Default voice set to Charon (Gemini - Charon)" -ForegroundColor Cyan
121|}
122|
123|function set-voice-zephyr {
124|    hermes config set tts.provider gemini | Out-Null
125|    hermes config set tts.gemini.voice Zephyr | Out-Null
126|    Invoke-HermesTTS "Zephyr is active."
127|    Write-Host "🎙️ Default voice set to Zephyr (Gemini - Zephyr)" -ForegroundColor Cyan
128|}
129|
130|function set-voice-kore {
131|    hermes config set tts.provider gemini | Out-Null
132|    hermes config set tts.gemini.voice Kore | Out-Null
133|    Invoke-HermesTTS "Kore is active."
134|    Write-Host "🎙️ Default voice set to Kore (Gemini - Kore)" -ForegroundColor Cyan
135|}
136|
137|# --- VRAM & Memory Lifecycle Helpers ---
138|function Update-VramActivity {
139|    $stateFile = "__PROJECT_ROOT__\.vram-idle-state.json"
140|    $timeStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
141|    
142|    $keepOn = $false
143|    if (Test-Path $stateFile) {
144|        try {
145|            $json = Get-Content $stateFile -Raw -ErrorAction SilentlyContinue | ConvertFrom-Json -ErrorAction SilentlyContinue
146|            if ($json -and $null -ne $json.KeepModelOn) {
147|                $keepOn = $json.KeepModelOn
148|            }
149|        } catch {}
150|    }
151|    
152|    $state = @{
153|        LastActivityTime = $timeStr
154|        KeepModelOn = $keepOn
155|    }
156|    $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8 -ErrorAction SilentlyContinue
157|}
158|
159|function Ensure-ModelLoaded {
160|    $models = lms ps 2>$null
161|    $hasModel = $false
162|    foreach ($line in $models) {
163|        if ($line -match "^\s*([a-zA-Z0-9_\-\.]+)\s*\|") {
164|            $hasModel = $true
165|            break
166|        }
167|    }
168|    if (-not $hasModel) {
169|        Write-Host "[J.A.R.V.I.S.] No active reasoning model found. Auto-loading Qwen 4B..." -ForegroundColor Yellow
170|        load-qwen
171|    }
172|}
173|
174|# --- Mem0 J.A.R.V.I.S. Memory Layer Functions ---
175|function remember {
176|    $text = $args -join " "
177|    if (-not $text.Trim()) {
178|        Write-Warning "Usage: remember <text_to_store>"
179|        return
180|    }
181|    
182|    # Touch VRAM Activity timestamp & auto-load model if needed
183|    Update-VramActivity
184|    Ensure-ModelLoaded
185|    
186|    & "__PROJECT_ROOT__\scripts\mem0-chat.ps1" -Action "add" -Text $text
187|}
188|
189|function recall {
190|    $query = $args -join " "
191|    if (-not $query.Trim()) {
192|        Write-Warning "Usage: recall <query_to_search>"
193|        return
194|    }
195|    
196|    # Touch VRAM Activity timestamp & auto-load model if needed
197|    Update-VramActivity
198|    Ensure-ModelLoaded
199|    
200|    & "__PROJECT_ROOT__\scripts\mem0-chat.ps1" -Action "search" -Query $query
201|}
202|
203|# --- LM Studio CLI Model Switcher Functions ---
204|$script:MscLmsModels = [ordered]@{
205|    qwen4    = @{ Key = 'qwen3-4b-instruct-2507'; Label = 'Qwen 4B (default — fast, Mem0)'; Task = 'light chat, memory, daily default' }
206|    qwen9    = @{ Key = 'qwen3.5-9b'; Label = 'Qwen 3.5 9B (smarter local chat)'; Task = 'better answers when you can wait' }
207|    coder14  = @{ Key = 'qwen2.5-coder-14b-instruct'; Label = 'Qwen Coder 14B'; Task = 'local coding — best fit for 16GB VRAM' }
208|    deepseek33 = @{ Key = 'deepseek-coder-33b-instruct'; Label = 'DeepSeek Coder 33B'; Task = 'heavy coding tests' }
209|    r1       = @{ Key = 'deepseek-r1-distill-qwen-14b'; Label = 'DeepSeek R1 14B'; Task = 'step-by-step reasoning' }
210|    arsenic  = @{ Key = 'arsenic-shahrazad-12b-v4.4'; Label = 'Arsenic Shahrazad 12B'; Task = 'creative writing / RP' }
211|}
212|
213|function Invoke-MscLmsLoad {
214|    param(
215|        [Parameter(Mandatory = $true)][string]$ModelKey,
216|        [Parameter(Mandatory = $true)][string]$OkMessage
217|    )
218|    Update-VramActivity
219|    lms load $ModelKey
220|    if ($LASTEXITCODE -ne 0) {
221|        Write-Host "[FAIL] Could not load: $ModelKey (lms exit $LASTEXITCODE)" -ForegroundColor Red
222|        return
223|    }
224|    Write-Host "[OK] $OkMessage" -ForegroundColor Green
225|    model-status
226|}
227|
228|function load-qwen4 { Invoke-MscLmsLoad -ModelKey $script:MscLmsModels.qwen4.Key -OkMessage 'Qwen 4B loaded (default)' }
229|function load-qwen9 { Invoke-MscLmsLoad -ModelKey $script:MscLmsModels.qwen9.Key -OkMessage 'Qwen 3.5 9B loaded' }
230|function load-coder14 { Invoke-MscLmsLoad -ModelKey $script:MscLmsModels.coder14.Key -OkMessage 'Qwen Coder 14B loaded' }
231|function load-deepseek33 { Invoke-MscLmsLoad -ModelKey $script:MscLmsModels.deepseek33.Key -OkMessage 'DeepSeek Coder 33B loaded' }
232|function load-r1 { Invoke-MscLmsLoad -ModelKey $script:MscLmsModels.r1.Key -OkMessage 'DeepSeek R1 14B loaded' }
233|function load-arsenic { Invoke-MscLmsLoad -ModelKey $script:MscLmsModels.arsenic.Key -OkMessage 'Arsenic Shahrazad 12B loaded' }
234|function load-qwen { load-qwen4 }
235|function load-deepseek { load-deepseek33 }
236|
237|function load-model {
238|    param([Parameter(Mandatory = $true, Position = 0)][string]$Name)
239|    $n = $Name.Trim().ToLower() -replace '\s+', '' -replace '_', ''
240|    $taskMap = @{
241|        default = 'qwen4'; fast = 'qwen4'; mem0 = 'qwen4'; memory = 'qwen4'
242|        smart = 'qwen9'; chat = 'qwen9'
243|        code = 'coder14'; coder = 'coder14'; dev = 'coder14'
244|        heavy = 'deepseek33'; deepseek = 'deepseek33'
245|        reason = 'r1'; think = 'r1'
246|        creative = 'arsenic'; story = 'arsenic'
247|    }
248|    if ($taskMap.ContainsKey($n)) { $n = $taskMap[$n] }
249|    if ($script:MscLmsModels.Contains($n)) {
250|        $entry = $script:MscLmsModels[$n]
251|        Invoke-MscLmsLoad -ModelKey $entry.Key -OkMessage "$($entry.Label) loaded"
252|        return
253|    }
254|    Invoke-MscLmsLoad -ModelKey $Name -OkMessage "Loaded $Name"
255|}
256|
257|function list-models {
258|    Write-Host ""
259|    Write-Host "LM Studio shortcuts (load-model <nick> or load-<nick>):" -ForegroundColor Cyan
260|    foreach ($prop in $script:MscLmsModels.Keys) {
261|        $e = $script:MscLmsModels[$prop]
262|        Write-Host ("  {0,-12} load-{0,-8} {1}" -f $prop, $e.Label) -ForegroundColor White
263|        Write-Host ("              -> {0}" -f $e.Task) -ForegroundColor DarkGray
264|    }
265|    Write-Host ""
266|    Write-Host "Task aliases: load-model code | smart | reason | creative | fast" -ForegroundColor DarkCyan
267|    Write-Host ""
268|    lms ls
269|}
270|
271|function unload-model {
272|    lms unload --all
273|    Write-Host "[OK] Model unloaded" -ForegroundColor Yellow
274|}
275|
276|function model-status {
277|    lms ps
278|}
279|
280|# --- Manual Overrides & VRAM Controls ---
281|function keep-model-on {
282|    $stateFile = "__PROJECT_ROOT__\.vram-idle-state.json"
283|    $timeStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
284|    $state = @{
285|        LastActivityTime = $timeStr
286|        KeepModelOn = $true
287|    }
288|    $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8 -ErrorAction SilentlyContinue
289|    Invoke-HermesTTS "Auto-unload disabled. Keeping model loaded."
290|    Write-Host "[J.A.R.V.I.S.] Auto-unload disabled. Keeping model loaded indefinitely." -ForegroundColor Yellow
291|}
292|
293|function keep-model-off {
294|    $stateFile = "__PROJECT_ROOT__\.vram-idle-state.json"
295|    $timeStr = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ss.fffZ")
296|    $state = @{
297|        LastActivityTime = $timeStr
298|        KeepModelOn = $false
299|    }
300|    $state | ConvertTo-Json | Out-File $stateFile -Encoding utf8 -ErrorAction SilentlyContinue
301|    Invoke-HermesTTS "Auto-unload safety restored."
302|    Write-Host "[J.A.R.V.I.S.] Auto-unload safety restored. Models will unload after fifteen minutes of idle time." -ForegroundColor Green
303|}
304|
305|function vram-status {
306|    powershell -File "__PROJECT_ROOT__\scripts\vram-idle-manager.ps1"
307|}
308|
309|function vram-unload {
310|    powershell -File "__PROJECT_ROOT__\scripts\vram-idle-manager.ps1" -UnloadNow
311|}
312|
313|function vram-daemon-start {
314|    $existing = Get-Job -Name "VramIdleManager" -ErrorAction SilentlyContinue
315|    if ($existing -and $existing.State -eq "Running") {
316|        Write-Host "[J.A.R.V.I.S.] VRAM Idle Manager Daemon is already running as background job." -ForegroundColor Yellow
317|        return
318|    }
319|    
320|    Start-Job -Name "VramIdleManager" -ScriptBlock {
321|        powershell -ExecutionPolicy Bypass -File "__PROJECT_ROOT__\scripts\vram-idle-manager.ps1" -Daemon
322|    } | Out-Null
323|    
324|    Invoke-HermesTTS "V RAM Idle Manager daemon started successfully."
325|    Write-Host "[OK] [J.A.R.V.I.S.] VRAM Idle Manager Daemon started as active background job." -ForegroundColor Green
326|}
327|
328|function vram-daemon-stop {
329|    Stop-Job -Name "VramIdleManager" -ErrorAction SilentlyContinue
330|    Remove-Job -Name "VramIdleManager" -ErrorAction SilentlyContinue
331|    Invoke-HermesTTS "V RAM Idle Manager daemon stopped."
332|    Write-Host "[STOP] [J.A.R.V.I.S.] VRAM Idle Manager Daemon stopped." -ForegroundColor Red
333|}
334|
335|# --- Free Image Generation Pipeline Function ---
336|function gen-image {
337|    param(
338|        [Parameter(Mandatory=$true, Position=0)]
339|        [string]$prompt,
340|
341|        [Parameter(Mandatory=$false)]
342|        [string]$Path,
343|
344|        [Parameter(Mandatory=$false)]
345|        [int]$Width = $null,
346|
347|        [Parameter(Mandatory=$false)]
348|        [int]$Height = $null
349|    )
350|
351|    # 1. Touch VRAM activity timestamp so our auto-unload daemon is in sync
352|    Update-VramActivity
353|
354|    # 1b. Dimension parsing from prompt hints
355|    $w = 1920
356|    $h = 1080
357|
358|    if ($prompt -match '\b(4k|4K|ultra hd|ultra HD)\b') {
359|        # Hugging Face serverless API limit is max 2048x2048. Scale 4K/ultra-hd widescreen to the absolute max 16:9 bounds.
360|        $w = 2048
361|        $h = 1152
362|    } elseif ($prompt -match '\b(hd|HD|1080p|1080P|widescreen)\b') {
363|        $w = 1920
364|        $h = 1080
365|    } elseif ($prompt -match '\b(vertical|phone|9:16)\b') {
366|        $w = 1080
367|        $h = 1920
368|    } elseif ($prompt -match '\b(1024x768|4:3)\b') {
369|        $w = 1024
370|        $h = 768
371|    }
372|
373|    # Override with explicitly passed parameters if provided
374|    if ($null -ne $Width -and $Width -gt 0) {
375|        $w = $Width
376|    }
377|    if ($null -ne $Height -and $Height -gt 0) {
378|        $h = $Height
379|    }
380|
381|    # 2. Setup path if not passed
382|    $projectRoot = "__PROJECT_ROOT__"
383|    $outputArg = ""
384|    $resolvedPath = ""
385|
386|    if ($Path) {
387|        $resolvedPath = [System.IO.Path]::GetFullPath($Path)
388|        $outputArg = "--output", $resolvedPath
389|    } else {
390|        $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
391|        $mediaDir = Join-Path $projectRoot "public\media"
392|        if (-not (Test-Path $mediaDir)) {
393|            New-Item -ItemType Directory -Path $mediaDir -Force | Out-Null
394|        }
395|        $resolvedPath = Join-Path $mediaDir "generated-$timestamp.png"
396|        $resolvedPath = [System.IO.Path]::GetFullPath($resolvedPath)
397|        $outputArg = "--output", $resolvedPath
398|    }
399|
400|    Write-Host "[J.A.R.V.I.S.] Generating image..." -ForegroundColor Yellow
401|    Write-Host "Prompt: $prompt" -ForegroundColor Cyan
402|    Write-Host "Dimensions: ${w}x${h}" -ForegroundColor Cyan
403|
404|    $pythonPath = "C:\Users\JONBEATZ\AppData\Local\Programs\Python\Python312\python.exe"
405|    $scriptPath = Join-Path $projectRoot "scripts\generate-image.py"
406|
407|    # 3. Call python image generation script
408|    $responseRaw = & $pythonPath $scriptPath --prompt $prompt --width $w --height $h $outputArg 2>$null
409|
410|    if (-not $responseRaw) {
411|        Write-Error "No response received from image generation layer."
412|        return
413|    }
414|
415|    try {
416|        $response = $responseRaw | ConvertFrom-Json
417|    } catch {
418|        Write-Host "[Raw Output] $responseRaw" -ForegroundColor Red
419|        Write-Error "Failed to parse JSON response from image generation layer."
420|        return
421|    }
422|
423|    if ($response -and $response.success) {
424|        $file = $response.file_path
425|        
426|        # Resolve the clean absolute path for Start-Process to avoid any weird formatting
427|        $cleanFile = Resolve-Path $file -ErrorAction SilentlyContinue
428|        if ($cleanFile) {
429|            $file = $cleanFile.ProviderPath
430|        } else {
431|            $file = [System.IO.Path]::GetFullPath($file)
432|        }
433|
434|        # Ensure full UTF-8 emoji support in the console host so emojis don't render as '??' and break link parsing
435|        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
436|        $displayFile = $file.Replace('\', '/')
437|
438|        Write-Host "[OK] [J.A.R.V.I.S.] Image successfully generated!" -ForegroundColor Green
439|        Write-Host "Saved to: $file" -ForegroundColor Green
440|
441|        # 4. Speak confirmation
442|        Invoke-HermesTTS "Image generated, opening now."
443|
444|        # 5. Automatically open the image in Windows native default photo viewer
445|        Start-Process -FilePath $file
446|    } else {
447|        $err = $response.error
448|        Write-Host "[J.A.R.V.I.S. Error] $err" -ForegroundColor Red
449|        Invoke-HermesTTS "Excuse me, Jon. I encountered an error while generating your image."
450|    }
451|}
452|
453|function gen-image-local {
454|    param(
455|        [Parameter(Mandatory = $true, Position = 0)]
456|        [string]$Prompt,
457|        [Parameter(Mandatory = $false)]
458|        [string]$OutputPath,
459|        [Parameter(Mandatory = $false)]
460|        [int]$Width = 0,
461|        [Parameter(Mandatory = $false)]
462|        [int]$Height = 0
463|    )
464|    Update-VramActivity
465|    $w = 1920; $h = 1080
466|    if ($Prompt -match '\b(square|1024x1024|1:1)\b') { $w = 1024; $h = 1024 }
467|    elseif ($Prompt -match '\b(vertical|phone|9:16)\b') { $w = 1080; $h = 1920 }
468|    if ($Width -gt 0) { $w = $Width }
469|    if ($Height -gt 0) { $h = $Height }
470|    $projectRoot = "__PROJECT_ROOT__"
471|    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
472|        $timestamp = (Get-Date).ToString("yyyyMMdd-HHmmss")
473|        $mediaDir = Join-Path $projectRoot "public\media"
474|        if (-not (Test-Path $mediaDir)) { New-Item -ItemType Directory -Path $mediaDir -Force | Out-Null }
475|        $OutputPath = Join-Path $mediaDir "generated-local-$timestamp.png"
476|    }
477|    $absoluteOutput = [System.IO.Path]::GetFullPath($OutputPath)
478|    $targetDir = [System.IO.Path]::GetDirectoryName($absoluteOutput)
479|    if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
480|    Write-Host "[J.A.R.V.I.S.] Local ComfyUI image generation (z-image-turbo)..." -ForegroundColor Yellow
481|    $workflowFile = "H:\AI_Models\ComfyUI\workflows\txt2img-gen-image-local.json"
482|    $overrides = @{
483|        "4.text" = $Prompt; "6.width" = $w; "6.height" = $h
484|        "8.seed" = Get-Random -Minimum 1 -Maximum 9999999999999
485|    }
486|    $resultFile = Invoke-ComfyPrompt -WorkflowPath $workflowFile -Overrides $overrides -FinalOutputPath $absoluteOutput
487|    if ($resultFile -and (Test-Path $resultFile)) {
488|        Write-Host "[OK] Saved to: $resultFile" -ForegroundColor Green
489|        Invoke-HermesTTS "Local image generated, opening now."
490|        Start-Process -FilePath $resultFile
491|        return $resultFile
492|    }
493|    Invoke-HermesTTS "Local image generation failed."
494|    return $null
495|}
496|
497|function hermes { & "C:\Users\JONBEATZ\AppData\Local\hermes\hermes-agent\venv\Scripts\hermes.exe" $args }
498|
499|# === ComfyUI Functions (New, Separate from gen-image) ===
500|
501|