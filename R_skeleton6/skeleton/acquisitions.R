# Expected Improvement
# @param x (`double()`): point(s) to determine the acquisition value(s)
# @param model ([mlr3::LearnerRegrKM]): GP to predict target function value(s)
# @param eta (`double(1)`): best objective value so far seen
# @return (`double()`): acquisition value(s)
expected_improvement = function(x, model, eta, ...) {
  p = model$predict_newdata(newdata = data.table(x = x))
  mu = p$response
  se = p$se
  stop("To Implement")
}

# Lower Confidence Bound
# @param x (`double()`): point(s) to determine the acquisition value(s)
# @param model ([mlr3::LearnerRegrKM]): GP to predict target function value(s)
# @param alpha (`double(1)`): weight for uncertainty
# @return (`double()`): acquisition value(s)
lower_confidence_bound = function(x, model, alpha = 1, ...) {
  p = model$predict_newdata(newdata = data.table(x = x))
  stop("To Implement")
}
