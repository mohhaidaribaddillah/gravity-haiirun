# Script untuk menambahkan Floating WhatsApp & Scroll to Top button ke semua HTML files

$htmlFiles = Get-ChildItem -Path "." -Filter "*.html"

$floatingButtons = @"

    <!-- Floating WhatsApp Button -->
    <a href="https://wa.me/6281234567890?text=Halo,%20saya%20ingin%20konsultasi!" 
       target="_blank"
       class="floating-whatsapp"
       aria-label="Chat WhatsApp">
        <svg width="32" height="32" fill="white" viewBox="0 0 24 24">
            <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
        </svg>
    </a>

    <!-- Scroll to Top Button -->
    <button id="scrollToTop" 
            class="scroll-to-top"
            aria-label="Scroll to top">
        <span class="material-symbols-outlined">arrow_upward</span>
    </button>

    <style>
        /* Floating WhatsApp Button */
        .floating-whatsapp {
            position: fixed;
            bottom: 20px;
            right: 20px;
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #25D366 0%, #128C7E 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(37, 211, 102, 0.4);
            z-index: 999;
            transition: all 0.3s ease;
            animation: pulse 2s infinite;
        }

        .floating-whatsapp:hover {
            transform: scale(1.1);
            box-shadow: 0 6px 20px rgba(37, 211, 102, 0.6);
        }

        @keyframes pulse {
            0%, 100% {
                box-shadow: 0 4px 12px rgba(37, 211, 102, 0.4);
            }
            50% {
                box-shadow: 0 4px 20px rgba(37, 211, 102, 0.7);
            }
        }

        /* Scroll to Top Button */
        .scroll-to-top {
            position: fixed;
            bottom: 90px;
            right: 20px;
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #f4d125 0%, #e0bd1f 100%);
            color: #1c190d;
            border: none;
            border-radius: 50%;
            display: none;
            align-items: center;
            justify-content: center;
            box-shadow: 0 4px 12px rgba(244, 209, 37, 0.4);
            cursor: pointer;
            z-index: 999;
            transition: all 0.3s ease;
        }

        .scroll-to-top:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 20px rgba(244, 209, 37, 0.6);
        }

        .scroll-to-top.show {
            display: flex;
        }

        /* Mobile Responsive */
        @media (max-width: 768px) {
            .floating-whatsapp {
                width: 56px;
                height: 56px;
                bottom: 16px;
                right: 16px;
            }

            .floating-whatsapp svg {
                width: 28px;
                height: 28px;
            }

            .scroll-to-top {
                width: 46px;
                height: 46px;
                bottom: 80px;
                right: 16px;
            }

            .scroll-to-top .material-symbols-outlined {
                font-size: 20px;
            }
        }

        /* Prevent overlap with sidebar on mobile */
        @media (max-width: 768px) {
            .sidebar.active ~ .floating-whatsapp,
            .sidebar.active ~ .scroll-to-top {
                opacity: 0.3;
                pointer-events: none;
            }
        }
    </style>

    <script>
        // Scroll to Top functionality
        const scrollToTopBtn = document.getElementById('scrollToTop');
        
        window.addEventListener('scroll', () => {
            if (window.pageYOffset > 300) {
                scrollToTopBtn.classList.add('show');
            } else {
                scrollToTopBtn.classList.remove('show');
            }
        });

        scrollToTopBtn.addEventListener('click', () => {
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    </script>
"@

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Check if floating buttons already exist
    if ($content -notmatch "floating-whatsapp") {
        # Find the closing </body> tag and insert before it
        $content = $content -replace '</body>', ($floatingButtons + "`n</body>")
        
        # Save the file
        Set-Content -Path $file.FullName -Value $content -NoNewline
        
        Write-Host "Added floating buttons to: $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host "Floating buttons already exist in: $($file.Name)" -ForegroundColor Yellow
    }
}

Write-Host "`nDone! Floating WhatsApp and Scroll-to-Top buttons added to all HTML files." -ForegroundColor Cyan
