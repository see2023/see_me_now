var frameCount = 0
var limitLoop = function (fn, fps) {
	// https://gist.githubusercontent.com/addyosmani/5434533/raw/a3e14fc7aee7bb4eab12a40028727ad19fe4880b/limitLoop.js

	// Use var then = Date.now(); if you
	// don't care about targetting < IE9
	var then = new Date().getTime();

	// custom fps, otherwise fallback to 60
	fps = fps || 60;
	var interval = 1000 / fps;

	return (function loop(time) {
		requestAnimationFrame(loop);

		// again, Date.now() if it's available
		var now = new Date().getTime();
		var delta = now - then;

		if (delta > interval) {
			// Update time
			// now - (delta % interval) is an improvement over just 
			// using then = now, which can end up lowering overall fps
			then = now - (delta % interval);

			// call the fn
			fn();
			window.frameCount++;
		}
	}(0));
};

// a function to get fps from window.frameCount
var lastTime = new Date().getTime();
var lastFrameCount = 0;
function getFPS() {
	var now = new Date().getTime();
	var fps = (window.frameCount - lastFrameCount) / (now - lastTime) * 1000;
	lastTime = now;
	lastFrameCount = window.frameCount;
	return fps;
}


class MorphTargetMapIndex {
	static arkitNames = ['eyeBlinkLeft', 'eyeLookDownLeft', 'eyeLookInLeft', 'eyeLookOutLeft', 'eyeLookUpLeft', 'eyeSquintLeft', 'eyeWideLeft', 'eyeBlinkRight',
		'eyeLookDownRight', 'eyeLookInRight', 'eyeLookOutRight', 'eyeLookUpRight', 'eyeSquintRight', 'eyeWideRight', 'jawForward', 'jawLeft', 'jawRight', 'jawOpen',
		'mouthClose', 'mouthDimpleLeft', 'mouthDimpleRight', 'mouthFrownLeft', 'mouthFrownRight', 'mouthFunnel', 'mouthLeft', 'mouthLowerDownLeft', 'mouthLowerDownRight',
		'mouthPressLeft', 'mouthPressRight', 'mouthPucker', 'mouthRight', 'mouthRollLower', 'mouthRollUpper', 'mouthShrugLower', 'mouthShrugUpper', 'mouthSmileLeft',
		'mouthSmileRight', 'mouthStretchLeft', 'mouthStretchRight', 'mouthUpperUpLeft', 'mouthUpperUpRight', 'browDownLeft', 'browDownRight', 'browInnerUp', 'browOuterUpLeft',
		'browOuterUpRight', 'cheekPuff', 'cheekSquintLeft', 'cheekSquintRight', 'noseSneerLeft', 'noseSneerRight', 'tongueOut', 'headRoll', 'leftEyeRoll', 'rightEyeRoll'];
	constructor() {
		this.indexMap = new Map();
		this.nameMap = new Map();
	}
	getIndexByArkitIndex(i) {
		return this.indexMap.get(i);
	}
	getIndexByName(name) {
		return this.nameMap.get(name);
	}
	getMappedSize() {
		return this.indexMap.size;
	}
	getTargetIndexByName(name, morphTargetManager) {
		for (let i = 0; i < morphTargetManager.numTargets; i++) {
			if (morphTargetManager.getTarget(i).name === name) {
				return i;
			}
		}
		return -1;
	}
	initMapWithMorphTargetManager(morphTargetManager) {
		for (let i = 0; i < MorphTargetMapIndex.arkitNames.length; i++) {
			let index = this.getTargetIndexByName(MorphTargetMapIndex.arkitNames[i], morphTargetManager);
			if (index >= 0) {
				this.indexMap.set(i, index);
				this.nameMap.set(MorphTargetMapIndex.arkitNames[i], index);
			}
		}
	}
}

function sendMessageToApp(message) {
	if (typeof Print !== 'undefined' && Print.postMessage) {
		Print.postMessage(message);
	} else {
		console.log('app msg:', message)
	}
}