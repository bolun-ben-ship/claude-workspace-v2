"""
Capture desktop and mobile screenshots for liankok.com visual audit.
Pages: homepage, /products/, /shop/
Viewports: Desktop 1920x1080, Mobile 375x812
"""
from playwright.sync_api import sync_playwright
import os

BASE_URL = "https://liankok.com"
SCREENSHOTS_DIR = "/Users/ben/Antigravity/RightClickAI-seo-workspace/clients/liankok.com/screenshots"

PAGES = [
    ("homepage", "/"),
    ("products", "/products/"),
    ("shop", "/shop/"),
]

VIEWPORTS = [
    ("desktop", 1920, 1080),
    ("mobile", 375, 812),
]

def capture_page(page, url, output_path):
    try:
        page.goto(url, wait_until='networkidle', timeout=30000)
        # Allow time for any lazy-loading or CLS to settle
        page.wait_for_timeout(2000)
        page.screenshot(path=output_path, full_page=False)
        print(f"  Saved: {output_path}")
        return True
    except Exception as e:
        print(f"  ERROR capturing {url}: {e}")
        return False

def main():
    os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

    with sync_playwright() as p:
        browser = p.chromium.launch()

        for vp_name, width, height in VIEWPORTS:
            print(f"\n--- {vp_name.upper()} ({width}x{height}) ---")

            # Set mobile user agent for mobile viewport
            if vp_name == "mobile":
                context = browser.new_context(
                    viewport={'width': width, 'height': height},
                    user_agent="Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
                )
            else:
                context = browser.new_context(
                    viewport={'width': width, 'height': height}
                )

            page = context.new_page()

            for page_name, path in PAGES:
                url = BASE_URL + path
                output_path = os.path.join(SCREENSHOTS_DIR, f"{page_name}-{vp_name}.png")
                print(f"  Capturing {url}...")
                capture_page(page, url, output_path)

            context.close()

        browser.close()

    print(f"\nAll screenshots saved to: {SCREENSHOTS_DIR}")

if __name__ == "__main__":
    main()
