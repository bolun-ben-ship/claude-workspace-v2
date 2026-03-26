"""
DOM and accessibility audit for liankok.com
Checks: H1 tags, meta descriptions, font sizes, tap target sizes, horizontal scroll
"""
from playwright.sync_api import sync_playwright
import json

BASE_URL = "https://liankok.com"
PAGES = [
    ("homepage", "/"),
    ("products", "/products/"),
    ("shop", "/shop/"),
]

def audit_page(page, url, page_name):
    page.goto(url, wait_until='networkidle', timeout=30000)
    page.wait_for_timeout(2000)

    results = {}

    # H1 tags
    h1_texts = page.evaluate("() => Array.from(document.querySelectorAll('h1')).map(el => el.innerText.trim())")
    results['h1_tags'] = h1_texts

    # Meta description
    meta_desc = page.evaluate("() => { const m = document.querySelector('meta[name=\"description\"]'); return m ? m.getAttribute('content') : null; }")
    results['meta_description'] = meta_desc

    # Page title
    results['page_title'] = page.title()

    # Check for horizontal scroll at mobile width
    scroll_width = page.evaluate("() => document.documentElement.scrollWidth")
    client_width = page.evaluate("() => document.documentElement.clientWidth")
    results['scroll_width'] = scroll_width
    results['client_width'] = client_width
    results['has_horizontal_scroll'] = scroll_width > client_width

    # Check for links / CTAs above fold (viewport height = 812px for mobile check)
    cta_buttons = page.evaluate("""() => {
        const elements = Array.from(document.querySelectorAll('a, button'));
        return elements
            .filter(el => {
                const rect = el.getBoundingClientRect();
                return rect.top >= 0 && rect.top <= 812 && rect.width > 0 && rect.height > 0;
            })
            .map(el => ({
                tag: el.tagName,
                text: el.innerText.trim().slice(0, 60),
                href: el.href || '',
                width: Math.round(el.getBoundingClientRect().width),
                height: Math.round(el.getBoundingClientRect().height),
                top: Math.round(el.getBoundingClientRect().top)
            }))
            .filter(el => el.text.length > 0)
            .slice(0, 20);
    }""")
    results['cta_elements_above_fold'] = cta_buttons

    # Check smallest tap targets
    small_targets = page.evaluate("""() => {
        return Array.from(document.querySelectorAll('a, button'))
            .filter(el => {
                const rect = el.getBoundingClientRect();
                return rect.width > 0 && rect.height > 0 && (rect.width < 44 || rect.height < 44);
            })
            .map(el => ({
                text: el.innerText.trim().slice(0, 40),
                width: Math.round(el.getBoundingClientRect().width),
                height: Math.round(el.getBoundingClientRect().height)
            }))
            .filter(el => el.text.length > 0)
            .slice(0, 10);
    }""")
    results['small_tap_targets'] = small_targets

    # Check body font size
    body_font = page.evaluate("() => getComputedStyle(document.body).fontSize")
    results['body_font_size'] = body_font

    # Nav visibility
    nav_visible = page.evaluate("""() => {
        const nav = document.querySelector('nav, header, .nav, .navbar, #navbar');
        if (!nav) return 'not found';
        const rect = nav.getBoundingClientRect();
        return { top: rect.top, height: rect.height, visible: rect.top >= 0 && rect.top < 200 };
    }""")
    results['nav_visibility'] = nav_visible

    # Shop page product count
    if page_name == 'shop':
        product_count = page.evaluate("""() => {
            const products = document.querySelectorAll('.product, .woocommerce-loop-product, li.product, .product-item');
            return products.length;
        }""")
        results['product_count_in_dom'] = product_count

    return results

def main():
    with sync_playwright() as p:
        # Desktop audit
        print("=== DESKTOP AUDIT (1920x1080) ===")
        browser = p.chromium.launch()
        context = browser.new_context(viewport={'width': 1920, 'height': 1080})
        page = context.new_page()
        for name, path in PAGES:
            url = BASE_URL + path
            print(f"\n-- {name} ({url}) --")
            results = audit_page(page, url, name)
            print(json.dumps(results, indent=2))
        context.close()

        # Mobile audit
        print("\n=== MOBILE AUDIT (375x812) ===")
        context = browser.new_context(
            viewport={'width': 375, 'height': 812},
            user_agent="Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        )
        page = context.new_page()
        for name, path in PAGES:
            url = BASE_URL + path
            print(f"\n-- {name} ({url}) mobile --")
            results = audit_page(page, url, name)
            print(json.dumps(results, indent=2))
        context.close()
        browser.close()

if __name__ == "__main__":
    main()
