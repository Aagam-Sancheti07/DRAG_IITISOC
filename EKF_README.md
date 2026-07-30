# Extended Kalman Filter — Design Notes

This document explains the logic behind `StateTransitionFcn.m` (prediction) and
`MeasurementFcn.m` (correction). For sensor noise modeling, R/Q derivation, and
test results, see the Phase 5 report.

## State Vector

```
x = [px, py, pz, vx, vy, vz, phi, theta, psi, p, q, r]
```
Position (m), velocity (m/s), Euler attitude angles (rad), body rotation rates (rad/s).

## Prediction Step — `StateTransitionFcn.m`

Given the current state estimate and the latest accelerometer reading, this
function predicts the state one timestep ahead.

1. **Rotate body-frame acceleration into the inertial frame.** The
   accelerometer measures acceleration relative to the rocket's own
   orientation, not the fixed ground frame. The current attitude estimate is
   used to build a rotation matrix (DCM) that transforms the reading into
   inertial coordinates, so it can be combined with position/velocity, which
   are tracked in the inertial frame.

2. **Correct for gravity.** An accelerometer measures *specific force*, not
   true acceleration — it does not sense gravity directly (this is why an
   accelerometer sitting still on a table reads ~9.81 m/s² upward, not zero).
   Gravity is added back in after the rotation step to recover true inertial
   acceleration.

3. **Integrate acceleration into velocity and position.** Standard motion
   equations advance velocity (`v += a·dt`) and position (`x += v·dt +
   ½·a·dt²`) using this corrected true acceleration — a physics-based
   prediction rather than a constant-velocity guess.

4. **Convert body rates to Euler angle rates.** Body rotation rates (p, q, r)
   are not numerically equal to the rate of change of roll/pitch/yaw in
   general. The correct kinematic transformation matrix is applied before
   integrating attitude forward, rather than treating them as interchangeable.

5. **Propagate body rates assuming they're constant over one step.** This is
   a deliberate simplification — no torque/moment model drives rotational
   acceleration in the prediction step. It's corrected at the very next
   gyroscope measurement, since updates run at 1 kHz.

## Correction Step — `MeasurementFcn.m`

Given the current state estimate, this function predicts what each sensor
*should* read if that estimate were exactly correct. The difference between
this prediction and the real sensor reading (the residual) drives the
Kalman update.

- **Gyroscope → body rates.** The expected reading is just `[p, q, r]` from
  the state vector directly — gyroscopes measure exactly this quantity, so no
  transformation is needed. This gives a direct, one-to-one correction path.

- **Barometer → altitude.** The expected reading is `pz` from the state
  vector directly, since barometric pressure translates to altitude.

Both expected values are computed *from the current state*, not hardcoded —
this is what lets the filter meaningfully correct itself whenever a real
measurement disagrees with the prediction. (An earlier version of this
function hardcoded the accelerometer's expected reading to zero regardless of
state, which made that channel mathematically incapable of correcting
anything — see project history for why acceleration was moved into the
prediction step instead of the correction step.)

## Known Limitations / Future Work

- Attitude kinematics use a standard Euler-angle rate transform, which is
  singular at ±90° pitch (gimbal lock). Not an issue for this flight profile,
  but worth switching to quaternion propagation if the rocket's expected
  attitude excursions grow.
- Body rates are propagated with a constant-rate assumption between updates
  rather than a full rotational dynamics model.
- Velocity estimation shows transient error concentrated in the first ~5
  seconds of flight (motor burn / highest dynamic pressure) — see Phase 5
  report, Section 5, for the test plot and discussion.
