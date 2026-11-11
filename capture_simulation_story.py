"""Capture each reachable runtime stage of the Organova simulation."""

from pathlib import Path
from PIL import Image
from playwright.sync_api import sync_playwright

OUTPUT = Path("assets/screenshots/actual/simulasi")
OUTPUT.mkdir(parents=True, exist_ok=True)


def tap_blue_button(page, image_path: Path):
    """Tap the blue-labelled Material button shown in the captured screen."""
    image = Image.open(image_path).convert("RGB")
    points = []
    for y in range(image.height):
        for x in range(image.width):
            red, green, blue = image.getpixel((x, y))
            if blue > red * 1.2 and blue > green * 1.05 and blue > 80 and red < 120:
                points.append((x, y))
    if not points:
        raise RuntimeError(f"No blue button label detected in {image_path}")
    x = sum(point[0] for point in points) / len(points)
    y = sum(point[1] for point in points) / len(points)
    page.touchscreen.tap(x / 2, y / 2)

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    context = browser.new_context(
        viewport={"width": 430, "height": 860}, device_scale_factor=2,
        has_touch=True, is_mobile=True,
    )
    page = context.new_page()
    page.goto("http://127.0.0.1:8090", wait_until="networkidle", timeout=60_000)
    page.wait_for_timeout(4_000)
    page.touchscreen.tap(215, 275)  # Mulai Simulasi
    page.wait_for_timeout(3_000)

    # Capture all four narrated intro states.  Wait until typewriting ends
    # before each tap so a single tap advances to the following dialog.
    for stage in range(1, 5):
        page.screenshot(path=str(OUTPUT / f"simulasi_{stage:02d}_intro.png"), full_page=True)
        page.touchscreen.tap(215, 750)
        page.wait_for_timeout(3_000)

    # Scene 2 loads its organisation profile from the simulation AI service.
    page.wait_for_timeout(8_000)
    page.screenshot(path=str(OUTPUT / "simulasi_05_profil_organisasi.png"), full_page=True)
    print("viewport", page.evaluate("({w: innerWidth, h: innerHeight, dpr: devicePixelRatio, canvas: [...document.querySelectorAll('canvas')].map(x => x.getBoundingClientRect().toJSON())})"))
    print("elements", page.evaluate("[...document.querySelectorAll('*')].map(x => ({tag:x.tagName, text:x.innerText?.slice(0,40), role:x.getAttribute('role'), rect:x.getBoundingClientRect().toJSON()})).filter(x => x.rect.width > 300 && x.rect.height > 100).slice(-12)"))

    # Continue to the first decision screen and capture the unselected state.
    tap_blue_button(page, OUTPUT / "simulasi_05_profil_organisasi.png")
    page.keyboard.press("Tab")
    page.keyboard.press("Enter")
    page.wait_for_timeout(2_000)
    page.screenshot(path=str(OUTPUT / "simulasi_06_diagnosis_kepemimpinan.png"), full_page=True)

    # Select the middle response, wait for the AI evaluation, and capture the
    # returned in-app result dialog when the service responds.
    page.touchscreen.tap(215, 335)
    page.wait_for_timeout(10_000)
    page.screenshot(path=str(OUTPUT / "simulasi_07_hasil_diagnosis.png"), full_page=True)

    # The Material result dialog exposes its primary action through keyboard
    # focus; this advances to the leadership-control stage.
    page.keyboard.press("Tab")
    page.keyboard.press("Enter")
    page.wait_for_timeout(2_000)
    page.screenshot(path=str(OUTPUT / "simulasi_08_kontrol_kepemimpinan.png"), full_page=True)

    # Run the control-level evaluation and capture its result.  The action is
    # the wide green button at the bottom of the portrait layout.
    page.touchscreen.tap(215, 810)
    page.wait_for_timeout(10_000)
    page.screenshot(path=str(OUTPUT / "simulasi_09_hasil_kontrol.png"), full_page=True)
    page.keyboard.press("Tab")
    page.keyboard.press("Enter")
    page.wait_for_timeout(2_000)
    page.screenshot(path=str(OUTPUT / "simulasi_10_kesiapan_tim.png"), full_page=True)

    # Select an instructional style for each team member, run the evaluation,
    # then advance through the Material result dialog to the crisis stage.
    page.touchscreen.tap(85, 190)   # Rina: Telling
    page.touchscreen.tap(180, 370)  # Budi: Selling
    page.touchscreen.tap(85, 580)   # Sari: Delegating
    page.touchscreen.tap(215, 810)  # Analisis AI
    page.wait_for_timeout(10_000)
    page.screenshot(path=str(OUTPUT / "simulasi_11_hasil_kesiapan_tim.png"), full_page=True)
    page.keyboard.press("Tab")
    page.keyboard.press("Enter")
    page.wait_for_timeout(2_000)
    page.screenshot(path=str(OUTPUT / "simulasi_12_simulasi_krisis.png"), full_page=True)

    # Resolve the crisis scenario, then capture the performance dashboard.
    page.touchscreen.tap(215, 400)
    page.wait_for_timeout(10_000)
    page.screenshot(path=str(OUTPUT / "simulasi_13_hasil_krisis.png"), full_page=True)
    page.keyboard.press("Tab")
    page.keyboard.press("Enter")
    page.wait_for_timeout(10_000)
    page.screenshot(path=str(OUTPUT / "simulasi_14_dashboard_kinerja.png"), full_page=True)

    # Open the final AI-coaching/reflection screen.
    page.touchscreen.tap(215, 810)
    page.wait_for_timeout(10_000)
    page.screenshot(path=str(OUTPUT / "simulasi_15_ai_coaching.png"), full_page=True)
    browser.close()
