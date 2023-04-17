class AnimationItem {
	constructor(name, curWeight, dstWeight, anim, loop) {
		this.name = name;
		this.curWeight = curWeight;
		this.dstWeight = dstWeight;
		this.anim = anim;
		this.loop = loop;
		this.frameCount = 0;
	}
}

class AnimationSwither {
	constructor(scene, ani) {
		this.scene = scene;
		this.backgroudAnimation = ani;
		this.switchTime = 0.8;
		this.switchFrameCount = FpsLimit * this.switchTime;
		console.log('switchTime', this.switchTime, 'switchFrameCount', this.switchFrameCount);
		this.defaultAnimationGroupName = 'Idle';
		// BABYLON.AnimationGroup
		let defaultAnimationGroup = this.scene.getAnimationGroupByName(this.defaultAnimationGroupName);
		if (defaultAnimationGroup == null) console.log('defaultAnimationGroup not found');
		this.defaultAnimationGroup = new AnimationItem(this.defaultAnimationGroupName, 1, 1, defaultAnimationGroup, true);
		this.currentAnimationGroup = new AnimationItem(null, 0, 0, null, false);
		this.lastAnimationGroup = new AnimationItem(null, 0, 0, null, false);
	}

	playAnimationGroup(name, loop, force = false) {
		if (this.currentAnimationGroup.name == name) {
			return;
		}
		if (this.lastAnimationGroup.anim != null) {
			if (!force) {
				console.log('waiting for last animation group to stop', this.lastAnimationGroup.name);
				return;
			} else {
				console.log('force stop last animation group', this.lastAnimationGroup.name)
				this.lastAnimationGroup.anim.stop();
			}
		}
		if (name == this.defaultAnimationGroupName) {
			// clone object currentAnimationGroup from defaultAnimationGroup
			this.lastAnimationGroup = this.currentAnimationGroup;
			this.lastAnimationGroup.dstWeight = 0;
			this.currentAnimationGroup = new AnimationItem(this.defaultAnimationGroup.name, 0, 1,
				this.defaultAnimationGroup.anim, this.defaultAnimationGroup.loop);
		} else {
			let anim = this.scene.getAnimationGroupByName(name);
			if (anim == null) {
				console.log('animation group not found: ' + name);
				return;
			}
			this.lastAnimationGroup = this.currentAnimationGroup;
			this.lastAnimationGroup.dstWeight = 0;
			this.currentAnimationGroup = new AnimationItem(name, 0, 1, anim, loop);
		}
		let lastWeight = this.lastAnimationGroup.curWeight;
		this.currentAnimationGroup.anim.start(loop);
		this.currentAnimationGroup.curWeight = 1 - lastWeight;
		this.currentAnimationGroup.anim.setWeightForAllAnimatables(1 - lastWeight);
		console.log('playAnimationGroup: ' + this.currentAnimationGroup.name + ', loop: ' + loop + ', curWeight: ' + this.currentAnimationGroup.curWeight);
		if (!loop) {
			this.backgroudAnimation.highlightOnAndZoomIn();
			// reset to default animation group when the none looping animation group played to end
			this.currentAnimationGroup.anim.onAnimationGroupEndObservable.addOnce(() => {
				this.backgroudAnimation.setMotionEnd();
				this.currentAnimationGroup.anim.onAnimationGroupEndObservable.clear();
				console.log('onAnimationGroupEndObservable: ' + this.currentAnimationGroup.name)
				this.playAnimationGroup(animationSwither.defaultAnimationGroupName, true, true);
			}
			);
		}
	}

	stopCurAnimationGroup() {
		if (this.currentAnimationGroup.anim === null) {
			console.log('currentAnimationGroup is null')
			return;
		}
		if (this.lastAnimationGroup.anim != null) {
			console.log('force stop last animation group to stop');
			this.lastAnimationGroup.anim.stop();
		}
		console.log('stopCurAnimationGroup: ' + this.currentAnimationGroup.name)
		this.lastAnimationGroup = this.currentAnimationGroup;
		this.lastAnimationGroup.dstWeight = 0;
		this.currentAnimationGroup = new AnimationItem(this.defaultAnimationGroup.name, 0, 1,
			this.defaultAnimationGroup.anim, this.defaultAnimationGroup.loop);
		this.currentAnimationGroup.anim.start(true);
		this.currentAnimationGroup.anim.setWeightForAllAnimatables(0);
	}


	onBeforeAnimation() {
		var delta = 1 / this.switchFrameCount;
		if (this.currentAnimationGroup && this.currentAnimationGroup.anim) {
			this.currentAnimationGroup.frameCount++;
			// this.currentAnimationGroup.curWeight += (this.currentAnimationGroup.dstWeight - this.currentAnimationGroup.curWeight) * delta;
			this.currentAnimationGroup.curWeight += delta;
			// console.log('------debug currentAnimationGroup.curWeight: ' + this.currentAnimationGroup.curWeight, 'frame count:', window.frameCount)
			this.currentAnimationGroup.curWeight = BABYLON.Scalar.Clamp(this.currentAnimationGroup.curWeight, 0, 1);
			this.currentAnimationGroup.anim.setWeightForAllAnimatables(this.currentAnimationGroup.curWeight);
			if (this.currentAnimationGroup.loop == false && this.currentAnimationGroup.curWeight >= 0.999 &&
				(this.currentAnimationGroup.anim.to - this.currentAnimationGroup.frameCount) < 0) {
				// adding time 
				console.log('stopping none loop current animation group: ' + this.currentAnimationGroup.name)
				this.playAnimationGroup(animationSwither.defaultAnimationGroupName, true);
			}
		}
		if (this.lastAnimationGroup && this.lastAnimationGroup.anim) {
			this.lastAnimationGroup.frameCount++;
			// this.lastAnimationGroup.curWeight += (this.lastAnimationGroup.dstWeight - this.lastAnimationGroup.curWeight) * delta;
			this.lastAnimationGroup.curWeight -= delta;
			this.lastAnimationGroup.curWeight = BABYLON.Scalar.Clamp(this.lastAnimationGroup.curWeight, 0, 1);
			this.lastAnimationGroup.anim.setWeightForAllAnimatables(this.lastAnimationGroup.curWeight);
			if (this.lastAnimationGroup.curWeight < 0.001) {
				console.log('stop last animation group: ' + this.lastAnimationGroup.name)
				this.lastAnimationGroup.anim.stop();
				this.lastAnimationGroup = new AnimationItem(null, 0, 0, null, false);
			}
		}
	}
}


// background animation to control light and camera 
class BackgroudAnimation {
	constructor(scene, camera, light, fps, minIntensity, maxIntensity, minZoom, maxZoom) {
		this.isHighlightOn = false;
		this.motionEnd = true;
		this.visemesEnd = true;
		this.scene = scene;
		this.camera = camera;
		this.light = light;
		this.fps = fps;
		this.minIntensity = minIntensity;
		this.maxIntensity = maxIntensity;
		this.minZoom = minZoom;
		this.maxZoom = maxZoom;
		this.lightKeys = [];
		this.zoomTime = 0.5;
		this.frameCount = this.fps * this.zoomTime;
		this.lightKeys.push({
			frame: 0,
			value: this.minIntensity
		});
		this.lightKeys.push({
			frame: this.frameCount,
			value: this.maxIntensity
		});
		this.animationLight = new BABYLON.Animation("lightAnimation", "intensity", this.fps, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CONSTANT);
		this.animationLight.setKeys(this.lightKeys);
		this.light.animations.push(this.animationLight);

		this.cameraKeys = [];
		this.cameraKeys.push({
			frame: 0,
			value: this.maxZoom
		});
		this.cameraKeys.push({
			frame: this.frameCount,
			value: this.minZoom
		});
		this.animationCamera = new BABYLON.Animation("cameraAnimation", "radius", this.fps, BABYLON.Animation.ANIMATIONTYPE_FLOAT, BABYLON.Animation.ANIMATIONLOOPMODE_CONSTANT);
		this.animationCamera.setKeys(this.cameraKeys);
		this.camera.animations.push(this.animationCamera);

	}
	highlightOnAndZoomIn() {
		if (this.isHighlightOn) {
			console.log('highlight is already on')
			return;
		}
		console.log('highlightOnAndZoomIn')
		this.isHighlightOn = true;
		this.motionEnd = false;
		this.visemesEnd = false;
		this.scene.beginAnimation(this.light, 0, this.frameCount, false);
		this.scene.beginAnimation(this.camera, 0, this.frameCount, false);
	}
	highlightOffAndZoomOut() {
		if (!this.isHighlightOn) {
			console.log('highlight is already off')
			return;
		}
		if (!this.motionEnd || !this.visemesEnd) {
			console.log('motion or visemes is not end', this.motionEnd, this.visemesEnd)
			return;
		}
		console.log('highlightOffAndZoomOut')
		this.isHighlightOn = false;
		this.scene.beginAnimation(this.light, this.frameCount, 0, false);
		this.scene.beginAnimation(this.camera, this.frameCount, 0, false);
	}
	setMotionEnd() {
		this.motionEnd = true;
		this.highlightOffAndZoomOut();
	}
	setVisemesEnd() {
		this.visemesEnd = true;
		this.highlightOffAndZoomOut();
	}
}

class SmileItem {
	constructor(value) {
		this.smileIndex = value;
		this.smileTime = new Date().getTime();
	}
}
class SmileIndex {
	// keep last 5 smile index value in 5 second, and calculate the current smile index interpolation
	constructor() {
		this.maxSmileCount = 5;
		this.smiles = [];
	}
	insertSmileIndex(value) {
		this.smiles.push(new SmileItem(value));
		if (this.smiles.length > this.maxSmileCount) {
			this.smiles.shift();
		}
		if (this.smiles.length > 1) {
			let lastSmile = this.smiles[this.smiles.length - 1];
			let firstSmile = this.smiles[0];
			if (lastSmile.smileTime - firstSmile.smileTime > this.maxSmileCount * 1000 + 1000) {
				this.smiles.shift();
			}
		}
	}
	getCurrentSmileIndex() {
		// calculate current smileIndex by last 5 smile and interpolate by time, more recent smile has more weight
		let weights = [];
		let totalWeight = 0;
		let now = new Date().getTime();
		for (var i = 0; i < this.smiles.length; i++) {
			let smile = this.smiles[i];
			let weight = 1 / ((now - smile.smileTime) / 1000 + 1);
			weights.push(weight);
			totalWeight += weight;
		}
		let smile = 0;
		for (var i = 0; i < this.smiles.length; i++) {
			smile += this.smiles[i].smileIndex * weights[i] / totalWeight;
		}
		return smile;
	}
}
