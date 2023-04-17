// import * as BABYLON from 'babylonjs';

const canvas = document.getElementById("renderCanvas");
const engine = new BABYLON.Engine(canvas, true);
let scene = null;
let human = null;
const indexMapper = new MorphTargetMapIndex();
let visemes = [];
let visemesStartTime;
let mouthSmileMorphTarget;
let smileLowerLimit = 0.3;
var animationSwither = null;
var backgroudAnimation = null;
var smileIndex = new SmileIndex();
const FpsLimit = 60;

const createScene = async function () {
	const scene = new BABYLON.Scene(engine);
	scene.clearColor = new BABYLON.Color4(0, 0, 0, 0);

	// turn on debug layer when url has debug=1
	window.location.search?.substr(1).split('&').forEach((item) => {
		if (item === 'debug=1') {
			setTimeout(() => {
				scene.debugLayer.show();
			}, 10 * 1000);
		}
	});

	const alpha = Math.PI / 2;
	const beta = Math.PI / 2;
	const cameraRadius = 3
	const camera = new BABYLON.ArcRotateCamera("camera", alpha, beta, cameraRadius, new BABYLON.Vector3(0, 1, 0));
	camera.lowerRadiusLimit = cameraRadius / 1.5;
	camera.upperRadiusLimit = cameraRadius * 1.5;
	camera.wheelDeltaPercentage = 0.01;
	camera.lowerAlphaLimit = alpha - Math.PI / 2;
	camera.upperAlphaLimit = alpha + Math.Pi / 2;
	camera.lowerBetaLimit = beta - Math.PI / 2;
	camera.upperBetaLimit = beta + Math.PI / 2;
	// camera.inputs.remove(camera.inputs.attached.pointers);
	camera.attachControl(canvas, true);
	const light = new BABYLON.HemisphericLight("light", new BABYLON.Vector3(10, 2, 0));
	light.intensity = 0.5
	console.log('light intensity', light.intensity)
	backgroudAnimation = new BackgroudAnimation(scene, camera, light, FpsLimit, light.intensity, 1.5, cameraRadius * 0.9, cameraRadius);

	// const meshes = await BABYLON.SceneLoader.ImportMeshAsync("", "./", "zhugeliang.low.mouthSmile.ARKit.glb");
	const meshes = await BABYLON.SceneLoader.ImportMeshAsync("", "./", "zhugeliang.talking.glb");
	human = meshes.meshes[1];
	console.log(human);
	indexMapper.initMapWithMorphTargetManager(human.morphTargetManager);
	console.log('indexMapper got', indexMapper.getMappedSize(), 'items');
	// const eyeBlinkLeftMorphtarget = human.morphTargetManager.getTarget(indexMapper.getIndexByName('eyeBlinkLeft'));
	// eyeBlinkLeftMorphtarget.influence = 1;
	mouthSmileMorphTarget = human.morphTargetManager.getTarget(16);
	mouthSmileMorphTarget.influence = smileLowerLimit;


	// under: Armature
	await BABYLON.SceneLoader.ImportAnimationsAsync('./', "RPM_Anime_Combined.glb", scene, false,
		BABYLON.SceneLoaderAnimationGroupLoadingMode.Stop, null);
	console.log(scene.animationGroups);


	//add environment and floor
	var skybox = BABYLON.MeshBuilder.CreateBox("skyBox", { size: 1000.0 }, scene);
	const skyMaterial = new BABYLON.SkyMaterial("skyMaterial", scene);
	skyMaterial.backFaceCulling = false;
	skyMaterial.inclination = 0.451;
	skyMaterial.azimuth = 0.5;

	skybox.material = skyMaterial;
	// skybox.rotation.y = Math.PI / 3;

	// create a dark floor
	var ground = BABYLON.MeshBuilder.CreateGround("ground", { width: 1000, height: 1000 }, scene);
	var groundMaterial = new BABYLON.StandardMaterial("ground", scene);
	groundMaterial.diffuseTexture = new BABYLON.Texture("textures/ground.jpg", scene);//, false, true, BABYLON.Texture.NEAREST_SAMPLINGMODE);
	ground.material = groundMaterial;
	ground.material.diffuseColor = new BABYLON.Color3(3, 3, 3);
	// set scale of the ground
	let scale = 0.2
	ground.scaling = new BABYLON.Vector3(scale, scale, scale);

	scene.stopAllAnimations();


	scene.registerBeforeRender(() => {
		// setting morphTarget.influence every frame
		let influenceFromInput = smileIndex.getCurrentSmileIndex();
		let influenceToSet = influenceFromInput / 100 * (1 - smileLowerLimit) + smileLowerLimit;
		mouthSmileMorphTarget.influence += (influenceToSet - mouthSmileMorphTarget.influence) * 0.03;
		// setting morphTarget.influence every frame
		// visemes 60 fps
		let now = new Date().getTime();
		if (!visemes || visemes.length < 1 || !visemesStartTime) {
			return;
		}
		var frameIndex = Math.floor((now - visemesStartTime) / (1000 / 60));
		if (frameIndex >= visemes.length) {
			visemes = [];
			visemesStartTime = 0;
			console.log('visemes end')
			backgroudAnimation.setVisemesEnd();
			return;
		}
		let frameCount = visemes.length;
		let morphCount = frameCount > 0 ? visemes[0].length : 0;
		if (morphCount < 1) return;
		// shoud be 55
		for (let i = 0; i < morphCount; i++) {
			let index = indexMapper.getIndexByArkitIndex(i);
			if (index >= 0) {
				human.morphTargetManager.getTarget(index).influence = visemes[frameIndex][i] / 1000;
			}
		}

	});

	return scene;
};

// visemesValuesString: [[171,164,38,0,0,95,0,171,164,74,0,0,95,0,81,28,0,254,161,182,110,11,4,20,29,30,16,56,51,123,99,64,57,18,100,23,24,290,287,20,20,14,14,91,0,0,21,54,58,38,39,0,13,-1,2], ...]
async function setVisemes(visemesValuesString) {
	setTimeout(() => {
		try {
			visemes = JSON.parse(visemesValuesString);
			visemesStartTime = new Date().getTime();
			// motions: Dance_GangnamStyle, Dance_Silly, Dance_Uprock, Greeting, Jump, Walk, Run, Walk_Backward
			// talk: idle0, idle1, idle2
			let talkAnimName = '';
			const talks = ['talk2', 'talk4']; // talk0, talk3
			const motions = ['Dance_GangnamStyle', 'Dance_Silly', 'Dance_Uprock', 'Greeting'];
			if (smileIndex.getCurrentSmileIndex() > 50) {
				talkAnimName = motions[Math.floor(Math.random() * motions.length)];
			} else {
				talkAnimName = talks[Math.floor(Math.random() * talks.length)];
			}
			sendMessageToApp("got new visemes.length: " + visemes.length + ', talkAnimName: ' + talkAnimName);
			animationSwither && animationSwither.playAnimationGroup(talkAnimName, false);
		} catch (error) {
			sendMessageToApp("error parsing visemes: " + error)
		}
	}, 10);
}


function setMouthSmileMorphTargetInfluence(influence) {
	// input influence: 0 - 100
	if (influence < 0 || influence > 100) return;
	smileIndex.insertSmileIndex(influence);
	console.log('setMouthSmileMorphTargetInfluence', influence)
}

// for console test
async function testVisemes() {
	fetch('visemes.json')
		.then(response => response.text())
		.then(data => {
			console.log('got visemes.json')
			setVisemes(data)
		}
		);
}


setInterval(() => {
	let divFps = document.getElementById("fps");
	divFps.innerHTML = 'FPS:' + getFPS().toFixed() + ", JSHeap: " + (performance.memory.usedJSHeapSize / 1024 / 1024).toFixed() + " M";
}, 1000);


async function main() {
	scene = await createScene();
	limitLoop(scene.render.bind(scene), FpsLimit);
	animationSwither = new AnimationSwither(scene, backgroudAnimation);
	scene.registerBeforeRender(animationSwither.onBeforeAnimation.bind(animationSwither));
	animationSwither.playAnimationGroup(animationSwither.defaultAnimationGroupName, true);

	// Watch for browser/canvas resize events
	window.addEventListener("resize", function () {
		engine.resize();
	});
};
main();

sendMessageToApp("hello from index.js");