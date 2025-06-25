const fs = require('fs');
const path = require('path');

// 读取主图标 SVG
const mainIconPath = path.join(__dirname, 'assets', 'icons', 'icon.svg');
const mainIconSvg = fs.readFileSync(mainIconPath, 'utf8');

// 不同尺寸的图标配置
const iconSizes = [
    { size: 16, name: 'icon-16x16.svg' },
    { size: 24, name: 'icon-24x24.svg' },
    { size: 32, name: 'icon-32x32.svg' },
    { size: 48, name: 'icon-48x48.svg' },
    { size: 64, name: 'icon-64x64.svg' },
    { size: 96, name: 'icon-96x96.svg' },
    { size: 128, name: 'icon-128x128.svg' },
    { size: 256, name: 'icon-256x256.svg' },
    { size: 512, name: 'icon-512x512.svg' }
];

// 为每个尺寸生成对应的 SVG
iconSizes.forEach(({ size, name }) => {
    let scaledSvg = mainIconSvg;

    // 根据尺寸调整字体大小和元素
    if (size <= 32) {
        // 小尺寸：简化设计，只保留 Jy 和基本形状
        scaledSvg = `<?xml version="1.0" encoding="UTF-8"?>
<svg width="${size}" height="${size}" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#0f0f23;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#16213e;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="textGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#00d4ff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0099cc;stop-opacity:1" />
    </linearGradient>
  </defs>
  <circle cx="256" cy="256" r="240" fill="url(#bgGradient)" stroke="#00d4ff" stroke-width="8"/>
  <text x="200" y="280" font-family="Arial Black" font-size="140" font-weight="900" fill="url(#textGradient)">J</text>
  <text x="280" y="280" font-family="Arial Black" font-size="110" font-weight="900" fill="url(#textGradient)">y</text>
</svg>`;
    } else if (size <= 64) {
        // 中等尺寸：保留主要元素
        scaledSvg = `<?xml version="1.0" encoding="UTF-8"?>
<svg width="${size}" height="${size}" viewBox="0 0 512 512" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#0f0f23;stop-opacity:1" />
      <stop offset="50%" style="stop-color:#1a1a2e;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#16213e;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="textGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#00d4ff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#0099cc;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="gasGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#ff6b35;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#ff4444;stop-opacity:1" />
    </linearGradient>
  </defs>
  <circle cx="256" cy="256" r="240" fill="url(#bgGradient)" stroke="#00d4ff" stroke-width="6"/>
  <g transform="translate(200, 140)">
    <rect x="20" y="30" width="60" height="100" rx="8" ry="8" fill="url(#gasGradient)"/>
    <rect x="30" y="15" width="40" height="20" rx="3" ry="3" fill="#666"/>
  </g>
  <text x="200" y="320" font-family="Arial Black" font-size="120" font-weight="900" fill="url(#textGradient)">J</text>
  <text x="280" y="320" font-family="Arial Black" font-size="90" font-weight="900" fill="url(#textGradient)">y</text>
</svg>`;
    } else {
        // 大尺寸：使用完整设计
        scaledSvg = scaledSvg.replace(/width="512" height="512"/, `width="${size}" height="${size}"`);
    }

    const iconPath = path.join(__dirname, 'assets', 'icons', name);
    fs.writeFileSync(iconPath, scaledSvg);
    console.log(`生成图标: ${name} (${size}x${size})`);
});

// 更新图标信息文件
const iconInfo = {
    name: "Jy技術團隊 - 瓦斯行管理系統",
    description: "現代化瓦斯行業務管理系統，整合AI助理與4D邊框設計",
    version: "1.0.0",
    author: "Jy技術團隊",
    created: new Date().toISOString(),
    sizes: iconSizes.map(({ size, name }) => ({ size, filename: name }))
};

const iconInfoPath = path.join(__dirname, 'assets', 'icons', 'icon-info.json');
fs.writeFileSync(iconInfoPath, JSON.stringify(iconInfo, null, 2));

console.log('✅ 所有图标生成完成！');
console.log(`📝 图标信息已更新: ${iconInfoPath}`);