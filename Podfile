# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'InvasivesBC' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for InvasivesBC
  pod 'IQKeyboardManagerSwift'
  pod 'ReachabilitySwift'
  pod 'Alamofire', '~> 4.7.3'
  pod 'Extended'
  pod 'RealmSwift'
  # Keycloack login
  pod 'SingleSignOn', :git => 'https://github.com/bcgov/mobile-authentication-ios.git', :tag => 'v1.0.6'

  target 'InvasivesBCTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'InvasivesBCUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
        config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
        config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
      end
    end
  end
end
