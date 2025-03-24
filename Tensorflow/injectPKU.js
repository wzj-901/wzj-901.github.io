const maxCaptchas = 13; // 需要采集的总数





// 创建目标画布（示例尺寸：总高度=20px * 3000张 = 60000px）
const targetCanvas = document.createElement('canvas');
targetCanvas.width = 60*10;   // 假设每张验证码宽度60px
targetCanvas.height = 20 ;
const targetCtx = targetCanvas.getContext('2d');
let captchaCount = 0;
// 下载最终大图的函数
function downloadResult() {
  const link = document.createElement('a');
  link.download = 'captchas_dataset.png';
  link.href = targetCanvas.toDataURL('image/png');
  link.click();
}
// 获取单张验证码并绘制
async function fetchAndDrawCaptcha() {
  try {
    // 生成带时间戳的请求URL（强制刷新）
    const captchaUrl = `https://course.pku.edu.cn/webapps/bb-sso-BBLEARN/execute/authValidate/getCaptcha?_=${Date.now()}`;
    // 使用fetch并禁用缓存
    const response = await fetch(captchaUrl, {
      headers: { 'Cache-Control': 'no-cache' }
    });
    // 将图片转为Image对象
    const blob = await response.blob();
    const img = new Image();
    img.src = URL.createObjectURL(blob);
    await new Promise((resolve, reject) => {
      img.onload = resolve;
      img.onerror = reject;
    });
    // 绘制到目标位置（水平排列）
    const xPosition = captchaCount * 60;
    targetCtx.drawImage(img,  xPosition,0);
    captchaCount++;
    console.log(`已采集 ${captchaCount}/${maxCaptchas}`);
    // 继续采集或完成
    if (captchaCount < maxCaptchas) {
      setTimeout(fetchAndDrawCaptcha, 200); // 200ms间隔防止封禁
    } else {
      downloadResult();
    }
  } catch (error) {
    console.error('采集出错，重试中...', error);
    setTimeout(fetchAndDrawCaptcha, 2000); // 失败后延迟重试
  }
}
// 开始采集
fetchAndDrawCaptcha();