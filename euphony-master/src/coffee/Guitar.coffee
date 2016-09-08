class Guitar

  loadGeo: (model) ->
    # collada
    loader = new THREE.ColladaLoader()
    gtr = this
    loader.options.convertUpAxis = true
    console.log "loading geometry of " + model.id
    loader.load model.file, (collada) ->
      @app.guitar.geometry[model.id] = collada.scene
      console.log('added2 in guitar ' + @app.guitar.geometry[model.id])
      if model.position != undefined and model.position != ''
        @app.guitar.geometry[model.id].position.set model.position[0], model.position[1], model.position[2]
      if model.rotation != undefined and model.rotation != ''
        @app.guitar.geometry[model.id].rotation.set model.rotation[0] * Math.PI / 180, model.rotation[1] * Math.PI / 180, model.rotation[2] * Math.PI / 180
      if model.mat != undefined and model.mat != ''
        gtr.setMaterial @app.guitar.geometry[model.id], model.mat, gtr
      if model.id == 'geoNeck'
        $.each @app.guitar.geometry[model.id].children, ->
          if /^fret/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matChromeHw, gtr
          else
            gtr.setMaterial $(this)[0], gtr.matNeck, gtr
          return
      if model.id == 'geoBridge' or model.id == 'geoStrings' or model.id == 'geoTuners'
        $.each @app.guitar.geometry[model.id].children, ->
          if /^string/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matStrings, gtr
          return
      if model.id == 'geoKnob'
        $.each @app.guitar.geometry[model.id].children, ->
          if /^transp/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matKnob1_transp, gtr
          else
            gtr.setMaterial $(this)[0], gtr.matKnob_gold, gtr
          return
      if model.id == 'geoSwitch'
        $.each @app.guitar.geometry[model.id].children, ->
          if /^hw/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matChromeHw, gtr
          else
            gtr.setMaterial $(this)[0], gtr.matWhitePlastic, gtr
          return
      if model.id == 'geoTuners'
        $.each @app.guitar.geometry[model.id].children, ->
          if /^hw/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matChromeHw, gtr
          else if /^string/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matStrings, gtr
          else
            gtr.setMaterial $(this)[0], gtr.matCreamPlastic, gtr
          return
      if model.id == 'geoTrussRodCover'
        $.each @app.guitar.geometry[model.id].children, ->
          if /^hw/.test($(this)[0].name)
            gtr.setMaterial $(this)[0], gtr.matChromeHw, gtr
          else
            gtr.setMaterial $(this)[0], gtr.matBell, gtr
          return
      # Fix pickups
      if model.id == 'geoPuNeck' or model.id == 'geoPuBridge'
        @app.guitar.geometry[model.id].getObjectByName('puPlastic1').children[0].material.setValues color: 0x000000
      @app.guitar.geometry[model.id].updateMatrix()
      @app.guitar.geometry[model.id].name = model.id
      return
    return

  loadGeoMultiple: (models) ->
    console.log 'in load geo multiple'
    @parts_array = ['geoNut', 'geoStrings', 'geoPuBridge', 'geoRingBridge', 'geoPuNeck', 'geoRingNeck', 'geoBridge', 'geoBody', 'geoNeck', 'geoTuners', 'geoKnob', 'geoSwitch', 'geoTrussRodCover', 'geoStrapPins']
    @loadGeo @parts.models[part] for part in @parts_array
    return
  # Custom Controls

  setDemoBody: (wood) ->
    texLoader.load 'tex/' + wood + '.jpg', (image) ->
    texture.image = image
    texture.needsUpdate = true 
    return
    return

  setDemoHwColor: (hwColor) ->
    setHwColor eval(hwColor)
    return

  setDemoFinish: (finish) ->
    if finish == 'gloss'
      matBody.setValues
        reflectivity: 0.15
        shininess: 80
    else
      matBody.setValues
        reflectivity: 0.02
        shininess: 40
    return

  setDemoDex: (dex) ->
    if dex == 'left'
      $(renderer.domElement).addClass 'leftie'
      controls.flipX = -1
    else
      $(renderer.domElement).removeClass 'leftie'
      controls.flipX = 1
    return

  setDemoPuColor: (puColor) ->
    @geometry['geoPuNeck'].getObjectByName('puPlastic1').children[0].material.setValues color: puColor
    @geometry['geoPuBridge'].getObjectByName('puPlastic1').children[0].material.setValues color: puColor
    return

    
  constructor: ->
    @geometry = {}
    @reflectionCube = undefined 
    path = 'env/'
    format = '.png'
    urls = [
      path + '0006' + format
      path + '0005' + format
      path + '0002' + format
      path + '0001' + format
      path + '0004' + format
      path + '0003' + format
    ]

    @reflectionCube = THREE.ImageUtils.loadTextureCube(urls)
    @reflectionCube.format = THREE.RGBFormat
    texture = new (THREE.Texture)
    texLoader = new (THREE.ImageLoader)
    texLoader.load 'tex/flamedMaple.jpg', (image) ->
      texture.image = image
      texture.needsUpdate = true
      texture.mapping = 'THREE.UVMapping'
      return
    texture_neck = new (THREE.Texture)
    texLoader_neck = new (THREE.ImageLoader)
    texLoader_neck.load 'tex/LP-neck.jpg', (image) ->
      texture_neck.image = image
      texture_neck.needsUpdate = true  
      texture_neck.mapping = 'THREE.UVMapping'
      return
    texture_bell = new (THREE.Texture)
    texLoader_bell = new (THREE.ImageLoader)
    texLoader_bell.load 'tex/LP-bell.jpg', (image) ->
      texture_bell.image = image
      texture_bell.needsUpdate = true  
      texture_bell.mapping = 'THREE.UVMapping'
      return
    @matBody = new (THREE.MeshPhongMaterial)(
      shininess: 70
      map: texture
      envMap: @reflectionCube
      combine: THREE.MixOperation
      reflectivity: 0.15)
    @matNeck = new (THREE.MeshPhongMaterial)(
      shininess: 70
      map: texture_neck
      envMap: @reflectionCube
      combine: THREE.MixOperation
      reflectivity: 0.15)
    @matBell = new (THREE.MeshPhongMaterial)(
      shininess: 20
      map: texture_bell)
    @matChromeHw = new (THREE.MeshPhongMaterial)(
      color: 0x000000
      specular: 0xffffff
      envMap: @reflectionCube
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
      envMap: @reflectionCube
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
      envMap: @reflectionCube
      combine: THREE.MixOperation
      reflectivity: 1
      opacity: 0.5
      transparent: true)
    @parts =
      models:
        geoNut:
          id: 'geoNut'
          file: 'model/nut-LP.dae'
          mat: @matWhitePlastic
        geoStrings:
          id: 'geoStrings'
          file: 'model/strings.dae'
          mat: @matStrings
        geoPuBridge:
          id: 'geoPuBridge'
          file: 'model/pu01.dae'
          mat: ''
          position: [0,  0, 0.08]
        geoRingBridge:
          id: 'geoRingBridge'
          file: 'model/ringHB.dae'
          mat: ''
        geoPuNeck:
          id: 'geoPuNeck'
          file: 'model/pu01.dae'
          mat: ''
          position: [10.46, 0, 0]
        geoRingNeck:
          id: 'geoRingNeck'
          file: 'model/ringHB.dae'
          mat: ''
          position: [10.46, 0, 0]
        geoBridge:
          id: 'geoBridge'
          file: 'model/TOM.dae'
          mat: @matChromeHw
          rotation: [0, -4.4, 0]
        geoBody:
          id: 'geoBody'
          file: 'model/H0H.dae'
          mat: @matBody
          rotation: [0,-4.4,0]
          position: [0,0,-0.85]
        geoNeck:
          id: 'geoNeck'
          file: 'model/LP-neck.dae'
          mat: ''
        geoTuners:
          id: 'geoTuners'
          file: 'model/LP.dae'
          mat: ''
        geoKnob:
          id: 'geoKnob'
          file: 'model/LP1.dae'
          mat: ''
          rotation: [0,-4.4,0]
          position: [0,0,-0.85]
        geoSwitch:
          id: 'geoSwitch'
          file: 'model/sw3_01.dae'
          mat: ''
          rotation: [0,-4.4,0]
          position: [0,0,-0.85]
        geoTrussRodCover:
          id: 'geoTrussRodCover'
          file: 'model/bell.dae'
          mat: @matBell
        geoStrapPins:
          id: 'geoStrapPins'
          file: 'model/strapPins.dae'
          mat: @matChromeHw
          rotation: [0,-4.4,0]
          position: [0,0,-0.85]
      options: {}
    @loadGeoMultiple @parts.models

  setMaterial: (node, material, gtr) ->
    node.material = material
    if node.children
      i = 0
      while i < node.children.length
        gtr.setMaterial node.children[i], material, gtr
        i++
    return

# export to global
@Guitar = Guitar