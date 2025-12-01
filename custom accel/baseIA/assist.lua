-- Mouse Steering (mod base) + throttle modes sin FFB

local uis = ac.getUI()

local steeringFinal = 0
local gasFinal = 0
local brakeFinal = 0

-- modos de acelerador
local throttleModes = {0.40, 0.70, 1.00}
local throttleIndex = 1
local shiftLock = false

-- ============================================================
--  UPDATE PRINCIPAL (mismo formato del mod)
-- ============================================================
function script.update(dt, deltaX, deltaY, useMouseButtons)

  --------------------------------------------------------------
  -- 1. Cambiar modo con SHIFT IZQUIERDA
  --------------------------------------------------------------
  local shift = ac.isKeyDown(ui.KeyIndex.LeftShift)
  if shift and not shiftLock then
    throttleIndex = throttleIndex + 1
    if throttleIndex > #throttleModes then
      throttleIndex = 1
    end
  end
  shiftLock = shift


  --------------------------------------------------------------
  -- 2. Acelerador (click izquierdo)
  --------------------------------------------------------------
  if useMouseButtons and ac.isKeyDown(ui.KeyIndex.LeftButton) then
    gasFinal = throttleModes[throttleIndex]
  else
    gasFinal = 0
  end

  --------------------------------------------------------------
  -- 3. Freno (click derecho)
  --------------------------------------------------------------
  if useMouseButtons and ac.isKeyDown(ui.KeyIndex.RightButton) then
    brakeFinal = 1
  else
    brakeFinal = 0
  end


  --------------------------------------------------------------
  -- 4. Steering (idéntico al mod, pero SIN FFB)
  --------------------------------------------------------------
  steeringFinal = steeringFinal + deltaX * 0.40
  steeringFinal = math.clamp(steeringFinal, -1, 1)


  --------------------------------------------------------------
  -- 5. Enviar input al GamepadFX
  --------------------------------------------------------------
  local state = ac.getJoypadState()
  state.steer = steeringFinal
  state.gas = gasFinal
  state.brake = brakeFinal
end
