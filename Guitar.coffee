class Guitar:

#	loadGeoMultiple = (models) ->
#		$.each models, (index) ->
#			loadGeo models[index]
#			return
#		return

	loadGeo = (model) ->
	  # collada
	  loader = new (THREE.ColladaLoader)
	  loader.options.convertUpAxis = true
	  loader.load model.file, (collada) ->
		geometry[model.id] = collada.scene
		if model.position != undefined and model.position != ''
		  geometry[model.id].position.set model.position[0], model.position[1], model.position[2]
		if model.rotation != undefined and model.rotation != ''
		  geometry[model.id].rotation.set model.rotation[0] * Math.PI / 180, model.rotation[1] * Math.PI / 180, model.rotation[2] * Math.PI / 180
		if model.mat != undefined and model.mat != ''
		  setMaterial geometry[model.id], model.mat
		if model.id == 'geoNeck'
		  $.each geometry[model.id].children, ->
			if /^fret/.test($(this)[0].name)
			  setMaterial $(this)[0], matChromeHw
			else
			  setMaterial $(this)[0], matNeck
			return
		if model.id == 'geoBridge' or model.id == 'geoStrings' or model.id == 'geoTuners'
		  $.each geometry[model.id].children, ->
			if /^string/.test($(this)[0].name)
			  setMaterial $(this)[0], matStrings
			return
		if model.id == 'geoKnob'
		  $.each geometry[model.id].children, ->
			if /^transp/.test($(this)[0].name)
			  setMaterial $(this)[0], matKnob1_transp
			else
			  setMaterial $(this)[0], matKnob_gold
			return
		if model.id == 'geoSwitch'
		  $.each geometry[model.id].children, ->
			if /^hw/.test($(this)[0].name)
			  setMaterial $(this)[0], matChromeHw
			else
			  setMaterial $(this)[0], matWhitePlastic
			return
		if model.id == 'geoTuners'
		  $.each geometry[model.id].children, ->
			if /^hw/.test($(this)[0].name)
			  setMaterial $(this)[0], matChromeHw
			else if /^string/.test($(this)[0].name)
			  setMaterial $(this)[0], matStrings
			else
			  setMaterial $(this)[0], matCreamPlastic
			return
		if model.id == 'geoTrussRodCover'
		  $.each geometry[model.id].children, ->
			if /^hw/.test($(this)[0].name)
			  setMaterial $(this)[0], matChromeHw
			else
			  setMaterial $(this)[0], matBell
			return
		# Fix pickups
		if model.id == 'geoPuNeck' or model.id == 'geoPuBridge'
		  geometry[model.id].getObjectByName('puPlastic1').children[0].material.setValues color: 0x000000
		geometry[model.id].updateMatrix()
		geometry[model.id].name = model.id
		return
	  return

	# Custom Controls

	setDemoBody = (wood) ->
	  texLoader.load 'file://C:/Users/Mariusz/Documents/AGH/animacja/tex/' + wood + '.jpg', (image) ->
		texture.image = image
		texture.needsUpdate = true
		render()
		return
	  return

	setDemoHwColor = (hwColor) ->
	  setHwColor eval(hwColor)
	  render()
	  return

	setDemoFinish = (finish) ->
	  if finish == 'gloss'
		matBody.setValues
		  reflectivity: 0.15
		  shininess: 80
	  else
		matBody.setValues
		  reflectivity: 0.02
		  shininess: 40
	  render()
	  return

	setDemoDex = (dex) ->
	  if dex == 'left'
		$(renderer.domElement).addClass 'leftie'
		controls.flipX = -1
	  else
		$(renderer.domElement).removeClass 'leftie'
		controls.flipX = 1
	  render()
	  return

	setDemoPuColor = (puColor) ->
	  geometry['geoPuNeck'].getObjectByName('puPlastic1').children[0].material.setValues color: puColor
	  geometry['geoPuBridge'].getObjectByName('puPlastic1').children[0].material.setValues color: puColor
	  render()
	  return

    
	constructor: ->
		@geometry = {}
		@reflectionCube = undefined 
		@path = 'file://C:/Users/Mariusz/Documents/AGH/animacja/env/'
		@format = '.png'
		@urls = [
		  path + '0006' + format
		  path + '0005' + format
		  path + '0002' + format
		  path + '0001' + format
		  path + '0004' + format
		  path + '0003' + format
		]

		@reflectionCube = THREE.ImageUtils.loadTextureCube(urls)
		@reflectionCube.format = THREE.RGBFormat
		@texture = new (THREE.Texture)
		@texLoader = new (THREE.ImageLoader)
		texLoader.load 'file://C:/Users/Mariusz/Documents/AGH/animacja/tex/flamedMaple.jpg', (image) ->
		  texture.image = image
		  texture.needsUpdate = true
		  texture.mapping = 'THREE.UVMapping'
		  render()
		  return
		texture_neck = new (THREE.Texture)
		texLoader_neck = new (THREE.ImageLoader)
		texLoader_neck.load 'file://C:/Users/Mariusz/Documents/AGH/animacja/tex/LP-neck.jpg', (image) ->
		  texture_neck.image = image
		  texture_neck.needsUpdate = true
		  texture_neck.mapping = 'THREE.UVMapping'
		  render()
		  return
		texture_bell = new (THREE.Texture)
		texLoader_bell = new (THREE.ImageLoader)
		texLoader_bell.load 'file://C:/Users/Mariusz/Documents/AGH/animacja/tex/LP-bell.jpg', (image) ->
		  texture_bell.image = image
		  texture_bell.needsUpdate = true  
		  texture_bell.mapping = 'THREE.UVMapping'
		  render()
		  return
		@matBody = new (THREE.MeshPhongMaterial)(
		  shininess: 70
		  map: texture
		  envMap: reflectionCube
		  combine: THREE.MixOperation
		  reflectivity: 0.15)
		@matNeck = new (THREE.MeshPhongMaterial)(
		  shininess: 70
		  map: texture_neck
		  envMap: reflectionCube
		  combine: THREE.MixOperation
		  reflectivity: 0.15)
		@matBell = new (THREE.MeshPhongMaterial)(
		  shininess: 20
		  map: texture_bell)
		@matChromeHw = new (THREE.MeshPhongMaterial)(
		  color: 0x000000
		  specular: 0xffffff
		  envMap: reflectionCube
		  combine: THREE.AddOperation
		  shininess: 90)
		@matStrings = new (THREE.MeshPhongMaterial)(
		  color: 0x666666
		  specular: 0xffffff
		  shininess: 100)
		@matBlackHw = new (THREE.MeshPhongMaterial)(
		  color: 0x010101
		  specular: 0x333333
		  shininess: 90)
		@matGoldHw = new (THREE.MeshPhongMaterial)(
		  color: 0xa3923c
		  specular: 0xe3c83e
		  envMap: reflectionCube
		  combine: THREE.MultiplyOperation
		  shininess: 90)
		@matBlackPlastic = new (THREE.MeshLambertMaterial)(color: 0x000000)
		@matWhitePlastic = new (THREE.MeshLambertMaterial)(color: 0xffffff)
		@matCreamPlastic = new (THREE.MeshLambertMaterial)(color: 0xa38f42)
		@matKnob_gold = new (THREE.MeshPhongMaterial)(
		  color: 0x584b09
		  specular: 0xb39c29
		  shininess: 20)
		@matKnob1_transp = new (THREE.MeshPhongMaterial)(
		  color: 0xc38500
		  envMap: reflectionCube
		  combine: THREE.MixOperation
		  reflectivity: 1
		  opacity: 0.5
		  transparent: true)

		@parts =
		  models:
			geoNut:
			  id: 'geoNut'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/nut-LP.dae'
			  mat: matWhitePlastic
			geoStrings:
			  id: 'geoStrings'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/strings.dae'
			  mat: matStrings
			geoPuBridge:
			  id: 'geoPuBridge'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/pu01.dae'
			  mat: ''
			  position: [0,	0, 0.08]
			geoRingBridge:
			  id: 'geoRingBridge'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/ringHB.dae'
			  mat: ''
			geoPuNeck:
			  id: 'geoPuNeck'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/pu01.dae'
			  mat: ''
			  position: [10.46, 0, 0]
			geoRingNeck:
			  id: 'geoRingNeck'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/ringHB.dae'
			  mat: ''
			  position: [10.46, 0, 0]
			geoBridge:
			  id: 'geoBridge'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/TOM.dae'
			  mat: matChromeHw
			  rotation: [0, -4.4, 0]
			geoBody:
			  id: 'geoBody'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/H0H.dae'
			  mat: matBody
			  rotation: [0,-4.4,0]
			  position: [0,0,-0.85]
			geoNeck:
			  id: 'geoNeck'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/LP-neck.dae'
			  mat: ''
			geoTuners:
			  id: 'geoTuners'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/LP.dae'
			  mat: ''
			geoKnob:
			  id: 'geoKnob'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/LP1.dae'
			  mat: ''
			  rotation: [0,-4.4,0]
			  position: [0,0,-0.85]
			geoSwitch:
			  id: 'geoSwitch'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/sw3_01.dae'
			  mat: ''
			  rotation: [0,-4.4,0]
			  position: [0,0,-0.85]
			geoTrussRodCover:
			  id: 'geoTrussRodCover'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/bell.dae'
			  mat: matBell
			geoStrapPins:
			  id: 'geoStrapPins'
			  file: 'file://C:/Users/Mariusz/Documents/AGH/animacja/model/strapPins.dae'
			  mat: matChromeHw
			  rotation: [0,-4.4,0]
			  position: [0,0,-0.85]
		  options: {}
		loadGeoMultiple parts.models

	setMaterial = (node, material) ->
	  node.material = material
	  if node.children
		i = 0
		while i < node.children.length
		  setMaterial node.children[i], material
		  i++
	  return

