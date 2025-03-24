// 1. 动态加载TensorFlow.js
if (!window.tf) { // 避免重复加载
	const tfScript = document.createElement('script');
	tfScript.src = 'https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@4.22.0/dist/tf.min.js';
	
	tfScript.onload = async () => {
	  // 2. 加载自定义模型
		// 1. 加载预训练模型
			const model = await tf.loadLayersModel(
				'https://wzj-901.github.io/Tensorflow/train-2.json',
				{
				weightUrlConverter: (url) => {
					// 完整指定权重路径
					return `https://wzj-901.github.io/Tensorflow/train-2.bin`;
				}
				}
			);
			
		
		// 2. 获取验证码图像元素
		const captchaImg = document.querySelector('img[src="/webapps/bb-sso-BBLEARN/execute/authValidate/getCaptcha"]');
		if (!captchaImg) return console.error('未找到验证码图像');
		
		// 3. 创建主画布处理图像（适配高20px宽60px）
		const mainCanvas = document.createElement('canvas');
		const ctx = mainCanvas.getContext('2d');
		[mainCanvas.width, mainCanvas.height] = [60, 20];
		ctx.drawImage(captchaImg, 0, 0, 60, 20);
		
		// 4. 切割为四个15x20的子图像
		const splitImages = Array.from({length:4}, (_,i) => {
			const subCanvas = document.createElement('canvas');
			[subCanvas.width, subCanvas.height] = [15, 20];
			subCanvas.getContext('2d').drawImage(
				mainCanvas,
				i*15, 0, 15, 20, // 源坐标
				0, 0, 15, 20      // 目标坐标
			);
			return subCanvas;
		});

		// 5. 预处理+批量预测
		const predictions = await tf.tidy(() => {
			// 转换四张子图为张量 [4, 15, 20, 3]
			const tensors = tf.stack(
				splitImages.map(canvas => 
					tf.browser.fromPixels(canvas)
					.transpose([1,0,2])
					.toFloat()
					.div(255)
					.neg()
					.add(1) // 与训练时相同的预处理
				)
			);
			
			// 执行预测并转换结果
			return model.predict(tensors).argMax(1).dataSync();
		});

		// 6. 输出预测结果
		console.log('验证码识别结果:', Array.from(predictions).join(''));
		document.getElementById('captcha').value = Array.from(predictions).join('');
		
		// 清理内存
		mainCanvas.remove();
		splitImages.forEach(c => c.remove());

	};
	
	tfScript.onerror = () => console.error('TensorFlow.js加载失败');
	document.head.appendChild(tfScript);
  } else {
	console.log('检测到页面已存在TensorFlow.js');
  }
  