platform :ios, '9.0'
use_frameworks!

target 'BestPractices' do
  pod 'Alamofire', '~> 4.2'
  pod 'SwiftyJSON', '~> 3.1'  
  pod 'RealmSwift', '~> 1.1'

  target 'BestPracticesTests' do
    inherit! :search_paths

    pod 'Quick', '~> 0.10'
    pod 'Nimble', '~> 5.0'
    pod 'Mockingjay', '~> 2.0'
    pod 'Fleet', '~> 2.0'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
