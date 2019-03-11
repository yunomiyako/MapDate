# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MapDemoApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MapDemoApp
  pod 'Alamofire'
  pod 'Cartography'
  pod 'MessageKit' , '~> 1.0.0'
  #####⬇︎TSUKASA⬇︎########
  pod 'FlexiblePageControl'
  pod 'MagazineLayout'
  #####⬆︎TSUKASA⬆︎########
# 以下追加
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == "MessageKit"
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end 
    end
end  
end
