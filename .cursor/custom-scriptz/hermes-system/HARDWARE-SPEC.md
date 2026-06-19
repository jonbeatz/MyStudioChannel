# VADER SITH BUILD: PC Master Reference

This document serves as the master hardware and system reference for the **VADER SITH BUILD** workstation running the MyStudioChannel local server infrastructure, J.A.R.V.I.S. reasoning nodes, and the Hermes workspace gateway.

## Workstation Hardware Specifications

### Core Processing & Platform
*   **CPU:** AMD Ryzen 7 9700X (8 Cores, 16 Threads, Granite Ridge, Socket AM5)
*   **AIO Cooler:** ID-COOLING FX360 PRO (360mm Radiator, Liquid Cooling)
*   **Motherboard:** Gigabyte B650 Gaming X AX V2 (Revision 1.2, AM5)
*   **RAM:** 32GB (2 x 16GB) Crucial Pro Overclocking DDR5-6000 (Dual Channel)

### Graphics & Compute
*   **GPU:** MSI Ventus GeForce RTX 5060 Ti 16GB GDDR7 (PCI Express 5.0 x16, physically running in x8 slot)
    *   *Model Name:* RTX 5060 Ti 16G VENTUS 2X OC PLUS
    *   *Role:* J.A.R.V.I.S. local reasoning (GGUF offloading), FLUX.1 / Stable Diffusion XL image generation pipelines.

### Power & Chassis
*   **PSU:** MSI MPG A850GS 850W Gold ATX 3.1 (Fully Modular)
*   **Case:** Montech AIR 903 MAX ATX Mid-Tower (High Airflow, pre-installed ARGB fans)

### Display Configuration
*   **Monitors:** 2x Sceptre Curved 24-inch 1080p LED Monitors

---

## Workstation Storage Matrix

### High-Speed Solid-State Storage (Boot & Workspaces)
*   **Drive C (Boot & Dev Workspace):** 2TB WD_BLACK SN850X NVMe SSD (PCIe Gen4, high-throughput workspace read/write)
*   **SATA SSD Array (High-Speed Storage):**
    *   **SSD 1:** 2TB TEAMGROUP QX SATA SSD
    *   **SSD 2:** 2TB Fanxiang SATA SSD

### Bulk Mechanical Storage (Backups & Data Pools)
*   **HDD Array (Bulk Data & backups):**
    *   **HDD 1:** 4TB Seagate Constellation Enterprise HDD
    *   **HDD 2:** 4TB MaxDigital Enterprise HDD

### Expansion Hardware
*   **Controller:** BEYIMEI 4-Port SATA PCIe Expansion Card
*   **Power Distribution:** StarTech 1-to-4 SATA Power Splitter Cable

---

## 💾 Local AI Integration Mapping (VRAM Allocations)
*   **16GB GDDR7 VRAM** allows highly optimized local offloading of large-context GGUF models.
*   **Qwen 4B / 9B** and **DeepSeek-R1-Distill-Qwen-14B** fits entirely within VRAM with active caching and high context window sizes (65k+).
*   **FLUX.1 / SDXL** weights utilize unet quants (`unet@q4_k_s` / `flux.2-klein-4b`) mapped securely inside local storage limits.
*   **VRAM Idle Manager (`vram-idle-manager.ps1`):** Active background monitoring daemon unloads models after 15 minutes of inactivity to restore fully unhampered resource levels for Next.js builds.
