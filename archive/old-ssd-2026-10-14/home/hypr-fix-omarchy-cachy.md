# Fix: NVIDIA + Hyprland Suspend/Resume Freeze

## TL;DR

> **Quick Summary**: Fix NVIDIA RTX 3060 + Hyprland freeze after suspend by applying kernel parameters, enabling NVIDIA services, and creating Hyprland pause services.
> 
> **Deliverables**:
> - Kernel parameters: `nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1`
> - Enabled services: `nvidia-suspend.service`, `nvidia-resume.service`
> - Custom services: `hyprland-suspend.service`, `hyprland-resume.service`
> - Configuration: hyprlock screencopy permission fix (if needed)
> 
> **Estimated Effort**: Medium (4-6 waves, 1-2 hours with testing)
> **Parallel Execution**: NO - Sequential waves with verification between each
> **Critical Path**: Wave 0 → Wave 1 → Wave 2 → Wave 3 → Wave 4

---

## Context

### Original Request
User on Omarchy (CachyOS/Arch), Hyprland, NVIDIA RTX 3060. After suspend, login screen (hyprlock) shows with blank input field (no placeholder), keyboard frozen, cannot switch TTY. Screen is completely unresponsive.

### Interview Summary
**System Info**:
- OS: Omarchy on CachyOS (Arch-based)
- WM: Hyprland (Wayland)
- GPU: NVIDIA RTX 3060 (Ampere)
- Hardware: Desktop (single dGPU, no hybrid/Optimus)
- Lock screen: hyprlock (implied from blank input field symptom)

**Symptoms**:
- Login screen appears but input field has no placeholder text
- Keyboard completely unresponsive
- Cannot switch to TTY (Ctrl+Alt+F3 fails)
- Complete freeze requiring hard reboot

### Metis Review
**Identified Gaps** (addressed in this plan):
- **Gap**: Assumed kernel params need adding — actually need to VERIFY first
- **Gap**: No isolation test to determine if issue is base system or Hyprland-specific
- **Gap**: Missing rollback commands for each change
- **Gap**: hyprlock config issues likely contributing (Issue #953 - screencopy/DPMS crashes)
- **Gap**: Need to check S0ix vs S3 suspend mode

**Guardrails Applied**:
- Test incrementally between waves
- Document rollback for every change
- Do not modify hyprlock until NVIDIA fixes verified insufficient
- Do not change NVIDIA driver version

---

## Work Objectives

### Core Objective
Fix suspend/resume freeze on Omarchy/Hyprland/NVIDIA RTX 3060 by addressing driver initialization timing and compositor coordination.

### Concrete Deliverables
- [ ] Verification of current kernel parameter state
- [ ] Kernel parameters set (if not already): `nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1`
- [ ] NVIDIA services enabled: `nvidia-suspend.service`, `nvidia-resume.service`
- [ ] Hyprland pause services: `hyprland-suspend.service`, `hyprland-resume.service`
- [ ] Screencopy permission for hyprlock (if needed)
- [ ] 3 successful suspend/resume cycles verified

### Definition of Done
- [ ] System suspends and resumes successfully 3 consecutive times
- [ ] hyprlock appears and accepts password input after resume
- [ ] Keyboard responsive after resume
- [ ] Can switch TTY after resume
- [ ] No errors in `journalctl -b -p 3` after resume

### Must Have
- Working suspend/resume without freeze
- Lock screen functional after resume
- Documented rollback commands

### Must NOT Have (Guardrails)
- DO NOT change NVIDIA driver version
- DO NOT switch to nouveau or open-source driver
- DO NOT switch to X11/Xorg
- DO NOT modify unrelated Hyprland settings
- DO NOT apply all fixes at once — incremental testing required
- DO NOT disable TTY switching permanently

---

## Verification Strategy

### Test Decision
- **Infrastructure exists**: YES (systemd, kernel params already configurable)
- **Automated tests**: NO (manual verification via suspend/resume cycles)
- **Framework**: None — manual system testing

### QA Policy
Every task MUST include verification commands that can be run to confirm success. Evidence will be captured via:
- **Logs**: `journalctl` output saved to files
- **Commands**: Exact command outputs compared against expected values
- **Testing**: Physical suspend/resume cycles

---

## Execution Strategy

### Wave Structure (Sequential - NO Parallelism)

Each wave MUST be completed and verified before proceeding to the next. This is critical for debugging — if a wave breaks suspend, we must rollback immediately.

```
Wave 0 (Isolation Test - Determine Root Cause):
└── Task 0.1: Test suspend from TTY without Hyprland

Wave 1 (Current State Verification):
├── Task 1.1: Check current kernel parameter state
├── Task 1.2: Check NVIDIA service status
├── Task 1.3: Check suspend mode (S0ix vs S3)
├── Task 1.4: Analyze logs from previous failed resume
└── Task 1.5: Check hyprlock configuration

Wave 2 (Kernel Parameters - Foundation):
└── Task 2.1: Add kernel parameters (if not already set)

Wave 3 (NVIDIA Services - Driver Coordination):
└── Task 3.1: Enable nvidia-suspend/resume services

Wave 4 (Hyprland Coordination - Compositor Timing):
└── Task 4.1: Create Hyprland SIGSTOP/CONT services

Wave 5 (Hyprlock Fixes - Conditional):
└── Task 5.1: Grant screencopy permission and adjust config

Wave 6 (Final Verification):
└── Task 6.1: 3-cycle suspend/resume test with evidence
```

### Wave Dependency Logic

- **Wave 0**: Can run immediately (no dependencies)
- **Wave 1**: Can run immediately (no dependencies)
- **Wave 2**: Depends on Wave 1 finding params not set
- **Wave 3**: Depends on Wave 2 success OR Wave 1 finding params already set
- **Wave 4**: Depends on Wave 3 success
- **Wave 5**: **CONDITIONAL** — Only if Wave 4 doesn't fix issue
- **Wave 6**: Depends on all previous waves

### Rollback Strategy

**EVERY wave documents exact rollback commands**:
- Wave 2: Remove kernel params from bootloader
- Wave 3: Disable NVIDIA services
- Wave 4: Remove Hyprland pause services
- Wave 5: Revert hyprlock config

---

## TODOs

- [ ] 0.1. Isolation Test: Suspend from TTY without Hyprland

  **What to do**:
  - Switch to TTY3 (Ctrl+Alt+F3)
  - Log in
  - Run: `sudo systemctl suspend`
  - Wait for suspend, then resume
  - Verify system is responsive

  **Must NOT do**:
  - Do not test from within Hyprland yet
  - Do not skip this step even if "obvious" it's Hyprland

  **Recommended Agent Profile**:
  - **Category**: `quick` (user guidance, minimal commands)
  - **Skills**: []
  - **Reason**: Simple diagnostic commands, no complex logic

  **Parallelization**:
  - **Can Run In Parallel**: NO (Wave 0 must complete first)
  - **Blocks**: Wave 2, 3, 4, 5, 6
  - **Blocked By**: None

  **Acceptance Criteria**:
  - [ ] Can switch to TTY3 successfully
  - [ ] `sudo systemctl suspend` initiates suspend
  - [ ] System resumes and shows TTY login prompt
  - [ ] Keyboard responsive on TTY
  - [ ] `systemctl is-system-running` returns "running"

  **Rollback**:
  - None needed (diagnostic only)

  **Commit**: NO

---

- [ ] 1.1. Check Current Kernel Parameter State

  **What to do**:
  - Read current kernel parameter values
  - Determine if parameters already set or need adding
  - Document current state for decision in Wave 2

  **Must NOT do**:
  - Do not assume parameters are not set
  - Do not modify anything yet

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []
  - **Reason**: Read-only diagnostic commands

  **Parallelization**:
  - **Can Run In Parallel**: NO (Wave 1 is sequential)
  - **Parallel Group**: Wave 1 (with 1.2, 1.3, 1.4, 1.5)
  - **Blocked By**: None
  - **Blocks**: Wave 2 (conditional)

  **Acceptance Criteria**:
  - [ ] `cat /sys/module/nvidia_drm/parameters/modeset` → shows "Y" or "N"
  - [ ] `cat /sys/module/nvidia_drm/parameters/fbdev` → shows "Y" or "N"
  - [ ] `sort /proc/driver/nvidia/params | grep PreserveVideoMemoryAllocations` → shows "0" or "1"
  - [ ] Document findings: params_set = true/false

  **Evidence to Capture**:
  - Screenshot or text output of the three parameter values
  - Saved to: `~/.sisyphus/evidence/wave1-kernel-params.txt`

  **Rollback**:
  - None needed (read-only)

  **Commit**: NO

---

- [ ] 1.2. Check NVIDIA Service Status

  **What to do**:
  - Check if nvidia-suspend, nvidia-resume services exist and are enabled
  - Check if nvidia-hibernate service exists (for hibernate support)

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Acceptance Criteria**:
  - [ ] `systemctl status nvidia-suspend.service` → check if enabled/running
  - [ ] `systemctl status nvidia-resume.service` → check if enabled/running
  - [ ] `systemctl status nvidia-hibernate.service` → check if exists
  - [ ] Document: services_enabled = true/false

  **Evidence**:
  - Output saved to: `~/.sisyphus/evidence/wave1-nvidia-services.txt`

  **Commit**: NO

---

- [ ] 1.3. Check Suspend Mode (S0ix vs S3)

  **What to do**:
  - Determine which suspend mode the system uses
  - S0ix (s2idle) has known issues with NVIDIA
  - S3 (deep) is more reliable but not all systems support it

  **Acceptance Criteria**:
  - [ ] `cat /sys/power/mem_sleep` → shows "[s2idle]" or "[deep]"
  - [ ] Document: suspend_mode = "s2idle" or "deep"

  **Evidence**:
  - Output saved to: `~/.sisyphus/evidence/wave1-suspend-mode.txt`

  **Commit**: NO

---

- [ ] 1.4. Analyze Logs from Previous Failed Resume

  **What to do**:
  - Check journalctl for errors from previous boot
  - Look for NVIDIA-related errors
  - Look for Hyprland/hyprlock errors
  - Identify specific failure points

  **Acceptance Criteria**:
  - [ ] `journalctl -b -1 -p 3` → check for errors from previous boot
  - [ ] `journalctl -b -1 | grep -i nvidia` → check NVIDIA messages
  - [ ] `journalctl -b -1 | grep -i hypr` → check Hyprland/hyprlock messages
  - [ ] Document: primary_error_source = "nvidia" | "hyprland" | "unknown"

  **Evidence**:
  - Logs saved to: `~/.sisyphus/evidence/wave1-journal-errors.txt`

  **Commit**: NO

---

- [ ] 1.5. Check hyprlock Configuration

  **What to do**:
  - Check if hyprlock has screencopy permission
  - Check hyprlock PAM configuration
  - Check if DPMS off is enabled (known to cause crashes)

  **Acceptance Criteria**:
  - [ ] `grep -r "screencopy" ~/.config/hypr/` → check for permission
  - [ ] `cat /etc/pam.d/hyprlock` → verify PAM config exists
  - [ ] `grep -i "dpms" ~/.config/hypr/hypridle.conf 2>/dev/null || echo "No hypridle.conf"` → check DPMS settings
  - [ ] Document: hyprlock_issues = true/false

  **Evidence**:
  - Config files backed up to: `~/.sisyphus/evidence/wave1-hyprlock-config/`

  **Commit**: NO

---

- [ ] 2.1. Add Kernel Parameters (Conditional - Only if not already set)

  **What to do**:
  - Add kernel parameters to bootloader (GRUB or systemd-boot)
  - Parameters: `nvidia_drm.modeset=1 nvidia_drm.fbdev=1 nvidia.NVreg_PreserveVideoMemoryAllocations=1`
  - CachyOS uses systemd-boot by default (check first!)

  **Must NOT do**:
  - Do not add if already set (from Wave 1.1)
  - Do not modify without backup of original config
  - Do not skip the reboot and test step

  **Recommended Agent Profile**:
  - **Category**: `quick` (file edits, commands)
  - **Skills**: []
  - **Reason**: Configuration file editing and bootloader updates

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Blocked By**: Wave 1.1 (must confirm params not set)
  - **Blocks**: Wave 3

  **Acceptance Criteria**:
  - [ ] Identify bootloader: `ls -la /boot/loader/` (systemd-boot) or check `/etc/default/grub` (GRUB)
  - [ ] Backup original config
  - [ ] Add parameters to kernel command line
  - [ ] Update bootloader (rebuild initramfs if GRUB)
  - [ ] Reboot
  - [ ] Verify: `cat /sys/module/nvidia_drm/parameters/modeset` → "Y"
  - [ ] Verify: `cat /sys/module/nvidia_drm/parameters/fbdev` → "Y"
  - [ ] Verify: `sort /proc/driver/nvidia/params | grep PreserveVideoMemoryAllocations` → "1"

  **Rollback**:
  ```bash
  # If systemd-boot:
  sudo cp /boot/loader/entries/*-backup.conf /boot/loader/entries/*.conf
  # If GRUB:
  sudo cp /etc/default/grub.backup /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  ```

  **Commit**: YES
  - Message: `fix(nvidia): add kernel parameters for suspend/resume`
  - Files: bootloader config

---

- [ ] 3.1. Enable NVIDIA Suspend/Resume Services

  **What to do**:
  - Enable nvidia-suspend.service
  - Enable nvidia-resume.service
  - Reload systemd daemon
  - Test suspend/resume from Hyprland

  **Must NOT do**:
  - Do not enable nvidia-hibernate unless specifically requested
  - Do not enable if already enabled (from Wave 1.2)

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Blocked By**: Wave 2 (or Wave 1 if params already set)
  - **Blocks**: Wave 4

  **Acceptance Criteria**:
  - [ ] `sudo systemctl enable nvidia-suspend.service`
  - [ ] `sudo systemctl enable nvidia-resume.service`
  - [ ] `sudo systemctl daemon-reload`
  - [ ] `systemctl is-enabled nvidia-suspend.service` → "enabled"
  - [ ] `systemctl is-enabled nvidia-resume.service` → "enabled"
  - [ ] Test suspend: `sudo systemctl suspend` (from Hyprland)
  - [ ] Resume and verify Hyprland is responsive
  - [ ] Run 3 suspend/resume cycles successfully

  **Rollback**:
  ```bash
  sudo systemctl disable nvidia-suspend.service
  sudo systemctl disable nvidia-resume.service
  sudo systemctl daemon-reload
  ```

  **Commit**: YES
  - Message: `fix(nvidia): enable suspend/resume services`

---

- [ ] 4.1. Create Hyprland SIGSTOP/CONT Services

  **What to do**:
  - Create script: `/usr/local/bin/hyprland-sleep.sh`
  - Create service: `/etc/systemd/system/hyprland-suspend.service`
  - Create service: `/etc/systemd/system/hyprland-resume.service`
  - Enable services
  - The STOP signal pauses Hyprland before NVIDIA suspend, CONT resumes after

  **Script Content** (`/usr/local/bin/hyprland-sleep.sh`):
  ```bash
  #!/bin/bash
  case "${1:-}" in
    suspend)
      killall -STOP Hyprland 2>/dev/null || true
      ;;
    resume)
      killall -CONT Hyprland 2>/dev/null || true
      ;;
  esac
  ```

  **Service** (`hyprland-suspend.service`):
  ```ini
  [Unit]
  Description=Pause Hyprland before suspend
  Before=systemd-suspend.service
  Before=systemd-hibernate.service
  Before=nvidia-suspend.service

  [Service]
  Type=oneshot
  ExecStart=/usr/local/bin/hyprland-sleep.sh suspend

  [Install]
  WantedBy=systemd-suspend.service
  WantedBy=systemd-hibernate.service
  ```

  **Service** (`hyprland-resume.service`):
  ```ini
  [Unit]
  Description=Resume Hyprland after suspend
  After=systemd-suspend.service
  After=systemd-hibernate.service
  After=nvidia-resume.service

  [Service]
  Type=oneshot
  ExecStart=/usr/local/bin/hyprland-sleep.sh resume

  [Install]
  WantedBy=systemd-suspend.service
  WantedBy=systemd-hibernate.service
  ```

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Blocked By**: Wave 3
  - **Blocks**: Wave 5 (conditional)

  **Acceptance Criteria**:
  - [ ] Script created and executable: `sudo chmod +x /usr/local/bin/hyprland-sleep.sh`
  - [ ] Both services created
  - [ ] `sudo systemctl daemon-reload`
  - [ ] `sudo systemctl enable hyprland-suspend.service`
  - [ ] `sudo systemctl enable hyprland-resume.service`
  - [ ] `systemctl is-enabled hyprland-suspend.service` → "enabled"
  - [ ] Test suspend: `sudo systemctl suspend`
  - [ ] Verify Hyprland responds after resume: `hyprctl clients | head -5`
  - [ ] Run 3 successful suspend/resume cycles

  **Rollback**:
  ```bash
  sudo systemctl disable hyprland-suspend.service
  sudo systemctl disable hyprland-resume.service
  sudo rm /usr/local/bin/hyprland-sleep.sh
  sudo rm /etc/systemd/system/hyprland-suspend.service
  sudo rm /etc/systemd/system/hyprland-resume.service
  sudo systemctl daemon-reload
  ```

  **Commit**: YES
  - Message: `fix(hyprland): add SIGSTOP/CONT suspend coordination`
  - Files: `/usr/local/bin/hyprland-sleep.sh`, systemd service files

---

- [ ] 5.1. Fix hyprlock Screencopy and DPMS (Conditional)

  **What to do**:
  - **ONLY if Wave 4 doesn't fix the issue**
  - Grant screencopy permission to hyprlock
  - Disable DPMS off in hypridle.conf (known to cause crashes)
  - Verify PAM configuration

  **Must NOT do**:
  - Do not apply unless Wave 4 fails
  - Do not switch to swaylock unless explicitly requested

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Blocked By**: Wave 4 (and Wave 4 failure)
  - **Blocks**: Wave 6

  **Acceptance Criteria**:
  - [ ] Add to `~/.config/hypr/hyprland.conf`:
    ```
    windowrulev2 = suppressevent maximize, class:hyprlock
    ```
  - [ ] Edit `~/.config/hypr/hypridle.conf`:
    - Remove or comment out any DPMS off settings before suspend
  - [ ] Verify `/etc/pam.d/hyprlock` exists and contains:
    ```
    auth include system-auth
    ```
  - [ ] Test suspend/resume 3 times
  - [ ] Verify hyprlock accepts password input

  **Rollback**:
  ```bash
  # Restore hyprland.conf from backup
  cp ~/.config/hypr/hyprland.conf.backup ~/.config/hypr/hyprland.conf
  # Restore hypridle.conf from backup
  cp ~/.config/hypr/hypridle.conf.backup ~/.config/hypr/hypridle.conf 2>/dev/null || true
  ```

  **Commit**: YES (if applied)
  - Message: `fix(hyprlock): grant screencopy, disable DPMS off`

---

- [ ] 6.1. Final Verification: 3-Cycle Suspend/Resume Test

  **What to do**:
  - Perform 3 complete suspend/resume cycles
  - Capture evidence after each cycle
  - Verify all success criteria met

  **Recommended Agent Profile**:
  - **Category**: `quick`
  - **Skills**: []

  **Parallelization**:
  - **Can Run In Parallel**: NO
  - **Blocked By**: All previous waves
  - **Blocks**: None (final wave)

  **Acceptance Criteria**:
  - [ ] Cycle 1: Suspend → Resume → hyprlock responsive → Unlock → All apps work
  - [ ] Cycle 2: Same as Cycle 1
  - [ ] Cycle 3: Same as Cycle 1
  - [ ] After each cycle, run: `journalctl -b -p 3 --since "5 minutes ago"` → no new errors
  - [ ] After each cycle, run: `hyprctl clients | wc -l` → returns count (confirms Hyprland responsive)
  - [ ] Document: all_cycles_passed = true

  **Evidence to Capture**:
  - Each cycle: Screenshot of successful login (if possible)
  - Each cycle: `journalctl` output saved to `~/.sisyphus/evidence/cycle-{N}-journal.txt`
  - Final summary: `~/.sisyphus/evidence/final-verification.txt`

  **Commit**: NO (verification only)

---

## Final Verification Wave (MANDATORY - after ALL implementation tasks)

> Run these checks in sequence to confirm the fix is complete and stable.

### Post-Fix Verification Checklist

- [ ] **System State Verification**
  ```bash
  cat /sys/module/nvidia_drm/parameters/modeset  # Should be "Y"
  cat /sys/module/nvidia_drm/parameters/fbdev     # Should be "Y"
  sort /proc/driver/nvidia/params | grep PreserveVideoMemoryAllocations  # Should be "1"
  systemctl is-enabled nvidia-suspend.service    # Should be "enabled"
  systemctl is-enabled nvidia-resume.service     # Should be "enabled"
  systemctl is-enabled hyprland-suspend.service  # Should be "enabled"
  systemctl is-enabled hyprland-resume.service   # Should be "enabled"
  ```

- [ ] **Functional Verification**
  - [ ] Suspend from Hyprland: `sudo systemctl suspend`
  - [ ] Resume and verify lock screen appears with placeholder text
  - [ ] Type password and unlock successfully
  - [ ] All previously open applications are still running
  - [ ] Keyboard responsive (can type, use shortcuts)
  - [ ] Can switch to TTY (Ctrl+Alt+F3) and back (Ctrl+Alt+F1)

- [ ] **Error Log Verification**
  ```bash
  journalctl -b -p 3  # Should show no new errors after resume
  ```

- [ ] **Stress Test** (Optional but Recommended)
  - [ ] Perform 5 rapid suspend/resume cycles (within 10 minutes)
  - [ ] All cycles should complete successfully

---

## Commit Strategy

- **Wave 2**: `fix(nvidia): add kernel parameters for suspend/resume` — bootloader config
- **Wave 3**: `fix(nvidia): enable suspend/resume services` — systemd services
- **Wave 4**: `fix(hyprland): add SIGSTOP/CONT suspend coordination` — custom services
- **Wave 5** (if applied): `fix(hyprlock): grant screencopy, disable DPMS off` — hyprlock config

---

## Success Criteria

### Verification Commands
```bash
# Check kernel parameters
[ "$(cat /sys/module/nvidia_drm/parameters/modeset)" = "Y" ] && echo "✓ modeset enabled"
[ "$(cat /sys/module/nvidia_drm/parameters/fbdev)" = "Y" ] && echo "✓ fbdev enabled"
[ "$(sort /proc/driver/nvidia/params | grep PreserveVideoMemoryAllocations | awk '{print $2}')" = "1" ] && echo "✓ video memory preservation enabled"

# Check services
systemctl is-enabled nvidia-suspend.service && echo "✓ nvidia-suspend enabled"
systemctl is-enabled nvidia-resume.service && echo "✓ nvidia-resume enabled"

# Test suspend
echo "Testing suspend in 5 seconds... (move mouse to cancel)"
sleep 5
sudo systemctl suspend
# After resume, verify:
hyprctl clients | head -1 && echo "✓ Hyprland responsive"
```

### Final Checklist
- [ ] Wave 0 passed (suspend works from TTY)
- [ ] Kernel parameters verified (modeset=1, fbdev=1, PreserveVideoMemoryAllocations=1)
- [ ] NVIDIA services enabled and functional
- [ ] Hyprland pause services enabled (if Wave 3 insufficient)
- [ ] 3 successful suspend/resume cycles completed
- [ ] hyprlock accepts password and unlocks successfully
- [ ] Keyboard responsive after resume
- [ ] Can switch TTY after resume
- [ ] No errors in journalctl after resume
- [ ] Rollback commands documented for each wave

---

## References

### Documentation
- Hyprland Wiki - NVIDIA: https://wiki.hyprland.org/Nvidia/
- Arch Wiki - NVIDIA/Tips and tricks: https://wiki.archlinux.org/title/NVIDIA/Tips_and_tricks
- Reddit - NVIDIA suspend fix: https://www.reddit.com/r/hyprland/comments/1b5f11n/solved_nvidia_suspend_wakeup_fix/
- GitHub - hyprland-suspend-fix: https://github.com/MysticBytes786/hyprland-suspend-fix

### Known Issues
- NVIDIA proprietary driver suspend/resume issues with Wayland
- Hyprlock Issue #953 - monitor disable crashes, DPMS off crashes, PAM issues
- S0ix (s2idle) suspend mode timing issues with NVIDIA
- Race condition between Hyprland and NVIDIA driver initialization

---

## Notes for Executor

1. **Wave 0 is critical** — Do not skip the TTY isolation test. If suspend fails from TTY, the issue is NOT Hyprland-specific and these fixes won't help.

2. **Incremental testing** — After EVERY wave that makes changes (2, 3, 4, 5), perform a full suspend/resume test. If it fails, rollback immediately and reassess.

3. **Conditional Wave 5** — Only apply hyprlock fixes if Wave 4 doesn't resolve the issue. The symptoms (blank input field) match hyprlock issues, but the root cause is likely NVIDIA timing.

4. **CachyOS specifics** — CachyOS uses systemd-boot by default, not GRUB. Check `/boot/loader/entries/` for kernel command line configuration.

5. **Evidence collection** — Save all command outputs to `~/.sisyphus/evidence/` for later review if issues persist.
