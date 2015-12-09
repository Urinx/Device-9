#!/bin/bash

#----------------------------------------------------
# 功能：为 Device 9 打包，要上传到 Pre.im 上进行测试和分发
# 作者：Urinx
# 创建日期：2015/12/9
# 备注：此脚本是根据之前苏宁易购泄漏的 iOS 客户端代码里的
# 	   ipa-build.sh 文件，在阅读和学习后将其为自己所用。
#----------------------------------------------------

bundle_id="Device-9"
app_name="Device 9"

project_path=$(pwd)
build_path=${project_path}/build
project_name=$(ls | grep xcodeproj | awk -F.xcodeproj '{print $1}')
target_name=${project_name}
result_path=${build_path}/build_release_$(date +%Y-%m-%d_%H_%M)
project_infoplist_path=${project_path}/${project_name}/Info.plist
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "$project_infoplist_path")
xcodeVersion=$(xcodebuild -version)
setting_out=${result_path}/build_setting.txt
appDir="${build_path}/Release-iphoneos/${target_name}.app"
ipa_name="${result_path}/${target_name}_${bundleShortVersion}.ipa"

echo "[*] 基本信息 ---------------------------------------------------"
echo "[*] 工程路径：${project_path}"
echo "[*] 编译路径：${build_path}"
echo "[*] 工程文件名称：${project_name}.xcodeproj"
echo "[*] target名称：${target_name}"
echo "[*] 最终打包路径：${result_path}"
echo "[*] Info.plist路径：${project_infoplist_path}"
echo "[*] App 版本号：${bundleShortVersion}"
echo -n "[*] Xcode 版本号："
echo $xcodeVersion

echo "[*] 开始打包 ---------------------------------------------------"
echo "[*] 清空 build 目录并建立新的目录"
if [[ -e "build" ]]; then
	rm -r build
fi
mkdir -p "${result_path}"
echo -n "[*] 检查是否选择了正确的发布证书: "
xcodebuild -showBuildSettings > "${setting_out}"
codeSign=$(grep "CODE_SIGN_IDENTITY" "${setting_out}" | cut  -d  "="  -f  2 | grep -o "[^ ]\+\( \+[^ ]\+\)*")
echo "$codeSign ✓"
echo -n "[*] 检查是否选择了正确的签名文件: "
provisionProfile=$(grep "PROVISIONING_PROFILE[^_]" "${setting_out}" | cut  -d  "="  -f  2 | grep -o "[^ ]\+\( \+[^ ]\+\)*")
echo "No ✘"
echo -n "[*] 检查 Bundle Identifier: "
bundleIdentifier=$(/usr/libexec/PlistBuddy -c "print CFBundleIdentifier" "$project_infoplist_path")
echo "$bundleIdentifier ✓"
build_dir=$(grep "CONFIGURATION_BUILD_DIR" "${setting_out}" | cut  -d  "="  -f  2 | grep -o "[^ ]\+\( \+[^ ]\+\)*")
echo "[*] 编译路径：${build_dir}"

echo -n "[*] clean 工程 "
xcodebuild clean >/dev/null && echo "✓"
echo -n "[*] 编译工程 "
xcodebuild -sdk iphoneos build >/dev/null && echo "✓" || exit
echo -n "[*] ipa 打包 "
xcrun -sdk iphoneos PackageApplication -v "${appDir}" -o "${ipa_name}" >/dev/null && echo "✓" || exit
echo "[*] 打包完成 ---------------------------------------------------"