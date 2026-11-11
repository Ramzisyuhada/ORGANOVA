"""
Script Capturing All Live Screenshots Organova (Flutter Web + Selenium)
Klik setiap menu pada aplikasi Organova yang sedang berjalan di http://localhost:8080.
"""

import os
import time
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

SCREENSHOT_DIR = r"d:\Flutter\organova\assets\screenshots"
os.makedirs(SCREENSHOT_DIR, exist_ok=True)

chrome_options = Options()
chrome_options.add_argument("--headless=new")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--window-size=480,920")

print("Starting ChromeDriver...")
driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

def click_coords(x, y):
    driver.execute_script(f"""
        var evt = new MouseEvent('click', {{
            clientX: {x},
            clientY: {y},
            bubbles: true,
            cancelable: true,
            view: window
        }});
        var el = document.elementFromPoint({x}, {y}) || document.body;
        el.dispatchEvent(evt);
    """)

try:
    print("Navigating to http://localhost:8080...")
    driver.get("http://localhost:8080")
    time.sleep(6) # Wait for initial loading
    
    # 1. Home Screen
    print("Capturing Home Screen...")
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig1_tampilan_utama.png"))
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig6_1_menu_home.png"))
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig8_1_tampilan_awal.png"))
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig8_2_navigasi_menu.png"))

    # 2. Open Materi Screen (Click Materi card ~ x=130, y=450)
    print("Opening Materi Screen...")
    click_coords(130, 450)
    time.sleep(3)
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig6_2_menu_materi.png"))
    
    # Back to home
    driver.get("http://localhost:8080")
    time.sleep(3)

    # 3. Open Video Screen (Click Video card ~ x=350, y=450)
    print("Opening Video Screen...")
    click_coords(350, 450)
    time.sleep(3)
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig6_3_menu_video.png"))
    
    # Back to home
    driver.get("http://localhost:8080")
    time.sleep(3)

    # 4. Open Kuis Screen (Click Kuis card ~ x=130, y=580)
    print("Opening Kuis Screen...")
    click_coords(130, 580)
    time.sleep(3)
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig6_5_menu_kuis.png"))
    
    # Back to home
    driver.get("http://localhost:8080")
    time.sleep(3)

    # 5. Open Tentang Screen (Click Tentang card ~ x=350, y=580)
    print("Opening Tentang Screen...")
    click_coords(350, 580)
    time.sleep(3)
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig6_6_menu_informasi.png"))
    
    # Back to home
    driver.get("http://localhost:8080")
    time.sleep(3)

    # 6. Open Simulasi Screen (Click Mulai Simulasi ~ x=240, y=300)
    print("Opening Simulasi / Intro Screen...")
    click_coords(240, 300)
    time.sleep(3)
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig6_4_menu_simulasi.png"))
    driver.save_screenshot(os.path.join(SCREENSHOT_DIR, "fig8_3_fitur_utama.png"))

    print("All live screenshots captured successfully!")

finally:
    driver.quit()
