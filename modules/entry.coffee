mouse2D = null
projector = null
camera = null
ray = null
scene = null
rollOverMesh = null
renderer = null
stats = null
cubeGeo = null
cubeMaterial = null
userMesh = null
user = null
offset = new THREE.Vector3 0, 150, -333
isShiftDown = no

init = ->
  container = document.createElement("div")
  document.body.appendChild container
  
  camera = new THREE.Camera 40, window.innerWidth / window.innerHeight, 1, 10000

  scene = new THREE.Scene
  rollOverGeo = new THREE.CubeGeometry(100, 100, 100)
  rollOverMaterial = new THREE.MeshBasicMaterial(
    color: 0xff0000
    opacity: 0.5
    transparent: true
  )
  rollOverMesh = new THREE.Mesh rollOverGeo, rollOverMaterial
  scene.addObject rollOverMesh
  
  userGeo = new THREE.CubeGeometry 10, 10, 10
  userMaterial = new THREE.MeshLambertMaterial color: 0x333333, shading: THREE.FlatShading
  
  userMesh = new THREE.Mesh(userGeo, userMaterial)
  # userMesh.position.y += 100
  scene.addObject userMesh
  camera.target = userMesh
  
  geometry = new THREE.Geometry
  
  geometry.vertices.push new THREE.Vertex new THREE.Vector3 0, 0, 0
  geometry.vertices.push new THREE.Vertex new THREE.Vector3 100, 0, 0
  
  geometry.vertices.push new THREE.Vertex new THREE.Vector3 0, 0, 0
  geometry.vertices.push new THREE.Vertex new THREE.Vector3 0, 100, 0

  geometry.vertices.push new THREE.Vertex new THREE.Vector3 0, 0, 0
  geometry.vertices.push new THREE.Vertex new THREE.Vector3 0, 0, 100

  material = new THREE.LineBasicMaterial color: 0x333333, linewidth: 3
  line = new THREE.Line geometry, material
  scene.addObject line
  
  cubeGeo = new THREE.CubeGeometry(100, 100, 100)
  cubeMaterial = new THREE.MeshLambertMaterial(
    color: 0xcccccc
    # shading: THREE.FlatShading
  )
  # cubeMaterial.color.setHSV 0.1, 0.7, 1.0
  projector = new THREE.Projector()
  plane = new THREE.Mesh(new THREE.PlaneGeometry(2000, 2000, 20, 20), new THREE.MeshBasicMaterial(
    color: 0x555555
    wireframe: true
  ))
  plane.rotation.x = -90 * Math.PI / 180
  scene.addObject plane
  mouse2D = new THREE.Vector3(0, 10000, 0.5)
  ray = new THREE.Ray(camera.position, null)
  ambientLight = new THREE.AmbientLight(0x606060)
  scene.addLight ambientLight
  directionalLight = new THREE.DirectionalLight(0xffffff)
  directionalLight.position.x = Math.random() - 0.5
  directionalLight.position.y = Math.random() - 0.5
  directionalLight.position.z = Math.random() - 0.5
  directionalLight.position.normalize()
  scene.addLight directionalLight
  directionalLight = new THREE.DirectionalLight(0x808080)
  directionalLight.position.x = Math.random() - 0.5
  directionalLight.position.y = Math.random() - 0.5
  directionalLight.position.z = Math.random() - 0.5
  directionalLight.position.normalize()
  scene.addLight directionalLight
  renderer = new THREE.WebGLRenderer(antialias: true)
  renderer.setSize window.innerWidth, window.innerHeight
  container.appendChild renderer.domElement
  stats = new Stats()
  stats.domElement.style.position = "absolute"
  stats.domElement.style.top = "0px"
  container.appendChild stats.domElement
  document.addEventListener "mousemove", onDocumentMouseMove, false
  document.addEventListener "mousedown", onDocumentMouseDown, false
  document.addEventListener "keydown", onDocumentKeyDown, false
  document.addEventListener "keyup", onDocumentKeyUp, false
  document.addEventListener "mousewheel", onDocumentMouseWheel, false

getRealIntersector = (intersects) ->
  i = 0
  while i < intersects.length
    intersector = intersects[i]
    return intersector  unless intersector.object == rollOverMesh
    i++
  null

setVoxelPosition = (intersector) ->
  tmpVec.copy intersector.face.normal
  voxelPosition.add intersector.point, intersector.object.matrixRotationWorld.multiplyVector3(tmpVec)
  voxelPosition.x = Math.floor(voxelPosition.x / 100) * 100 + 50
  voxelPosition.y = Math.floor(voxelPosition.y / 100) * 100 + 50
  voxelPosition.z = Math.floor(voxelPosition.z / 100) * 100 + 50

onDocumentMouseMove = (event) ->
  event.preventDefault()
  mouse2D.x = (event.clientX / window.innerWidth) * 2 - 1
  mouse2D.y = -(event.clientY / window.innerHeight) * 2 + 1

onDocumentMouseDown = (event) ->
  event.preventDefault()
  intersects = ray.intersectScene(scene)
  if intersects.length > 0
    intersector = getRealIntersector(intersects)
    if isCtrlDown
      scene.removeObject intersector.object  unless intersector.object == plane
    else
      intersector = getRealIntersector(intersects)
      setVoxelPosition intersector
      voxel = new THREE.Mesh(cubeGeo, cubeMaterial)
      voxel.position.copy voxelPosition
      voxel.matrixAutoUpdate = false
      voxel.updateMatrix()
      scene.addObject voxel

      avatarGeo = new THREE.CubeGeometry 10, 10, 10
      voxel = new THREE.Mesh(avatarGeo, cubeMaterial)
      voxel.position.copy voxelPosition
      voxel.position.setLength (voxel.position.length() / 10)
      userMesh.addChild voxel

keys = {}

onDocumentKeyDown = (event) ->
  keys[event.which] = on
  
  switch event.keyCode
    when 16
      isShiftDown = yes
    when 17
      isCtrlDown = yes

onDocumentKeyUp = (event) ->
  delete keys[event.which]
  
  switch event.keyCode
    when 16
      isShiftDown = no
    when 17
      isCtrlDown = no

onDocumentMouseWheel = (event) ->
  offset.setLength offset.length() * (1 + (event.wheelDelta / 2000))

save = ->
  window.open renderer.domElement.toDataURL("image/png"), "mywindow"

animate = ->
  requestAnimationFrame animate
  render()
  stats.update()

matrix = new THREE.Matrix4

render = ->
  if isShiftDown
    matrix.setRotationY mouse2D.x / 50
    offset = matrix.multiplyVector3 offset
  
  mouse3D = projector.unprojectVector(mouse2D.clone(), camera)
  
  ray.direction = mouse3D.subSelf(camera.position).normalize()
  
  intersects = ray.intersectScene scene
  
  if intersects.length > 0

    intersector = getRealIntersector intersects
    
    if intersector
      setVoxelPosition intersector
      rollOverMesh.position = voxelPosition
  
  if keys[87] or keys[38]
    camera.target.translateZ 5
  if keys[83] or keys[40]
    camera.target.translateZ -5
  
  if keys[65] or keys[37]
    camera.target.translateX 5
  if keys[68] or keys[39]
    camera.target.translateX -5
  
  if keys[81]
    camera.target.rotation.y += 0.033
  if keys[69]
    camera.target.rotation.y -= 0.033
  
  camera.position.copy camera.target.position
  camera.position.addSelf offset
  
  renderer.render scene, camera

Detector.addGetWebGLMessage() unless Detector.webgl

isShiftDown = false
theta = 45
isCtrlDown = false
voxelPosition = new THREE.Vector3()
tmpVec = new THREE.Vector3()

init()
animate()