const { execSync } = require('child_process')

/**
 * 获取当前git分支名称
 * @returns {string}
 */
function getCurrentGitBranch() {
  const buffer = execSync('git rev-parse --abbrev-ref HEAD')
  return buffer.toString().trim()
}

exports.getCurrentGitBranch = getCurrentGitBranch
