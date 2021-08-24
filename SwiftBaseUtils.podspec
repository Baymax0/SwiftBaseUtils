Pod::Spec.new do |s|
    s.name = "SwiftBaseUtils"
    s.author = {'lee' => 'jzdd327@163.com'}
    s.version = '0.0.1'

    s.requires_arc = true
    s.homepage = "https://github.com/Baymax0/SwiftBaseUtils"

    s.source = { :git => 'https://github.com/Baymax0/SwiftBaseUtils.git', :tag => s.version }

    s.summary = 'A base tool for swift develop'
    s.description = 'custom base tool for swift develop'

    s.ios.deployment_target = '9.0'

    s.source_files = 'Source/SwiftBaseUtils/*.{swift,h,m,png,sqlite}'
    s.source_files = 'Source/SwiftBaseUtils/**/*.{swift,h,m,png,sqlite}'

    s.framework = "Foundation"
    s.framework = "UIKit"
end
