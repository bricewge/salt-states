powersaving.install:
  pkg.installed:
    - pkgs:
      - acpi
      - acpid
      - cpupower

# disabeling intel_cpufreq
