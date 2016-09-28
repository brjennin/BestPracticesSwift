platform :ios, '9.0'
use_frameworks!

target 'BestPractices' do
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON', '~> 3.1'  
  pod 'RealmSwift', '~> 1.1'

  target 'BestPracticesTests' do
    inherit! :search_paths

    pod 'Quick', '~> 0.10'
    pod 'Nimble', '~> 5.0'
    pod 'Mockingjay', branch: 'kylef/swift-3.0', git: 'git@github.com:kylef/Mockingjay.git'
    pod 'Fleet', branch: 'swift3', git: 'git@github.com:brjennin/Fleet.git'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
