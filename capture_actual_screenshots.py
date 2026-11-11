"""Capture runtime screenshots from the locally built Organova web app."""

from pathlib import Path
from playwright.sync_api import sync_playwright

OUTPUT = Path("assets/screenshots/actual")
OUTPUT.mkdir(parents=True, exist_ok=True)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(viewport={"width": 430, "height": 860}, device_scale_factor=2)

    def open_home():
        page.goto("http://127.0.0.1:8090", wait_until="networkidle", timeout=60_000)
        page.wait_for_timeout(4_000)

    open_home()
    page.screenshot(path=str(OUTPUT / "home.png"), full_page=True)

    # Coordinates are in CSS pixels for the 430 x 860 mobile viewport.
    page.mouse.click(125, 480)
    page.wait_for_timeout(1_500)
    page.screenshot(path=str(OUTPUT / "materi.png"), full_page=True)

    open_home()
    page.mouse.click(315, 480)
    page.wait_for_timeout(1_500)
    page.screenshot(path=str(OUTPUT / "kuis.png"), full_page=True)

    open_home()
    page.mouse.click(125, 650)
    page.wait_for_timeout(1_500)
    page.screenshot(path=str(OUTPUT / "tentang.png"), full_page=True)

    open_home()
    page.mouse.click(215, 275)
    page.wait_for_timeout(2_000)
    page.screenshot(path=str(OUTPUT / "simulasi_intro.png"), full_page=True)

    # Complete the four introductory dialog interactions to reach the first
    # decision scene, then capture its active-state UI.  The dialog card is
    # located at the lower part of the mobile viewport.
    page.wait_for_timeout(500)
    for _ in range(4):
        page.mouse.click(215, 780)
        page.wait_for_timeout(2_100)
    page.wait_for_timeout(1_500)
    page.screenshot(path=str(OUTPUT / "simulasi_keputusan.png"), full_page=True)
    browser.close()
