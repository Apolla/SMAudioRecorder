# SMAudioRecorder

用于ios录音，已解决录音播放时声音太小的问题

导入`lame.a` 编译时可能会报类似 `arm64` 之类的错误，这时只需要在`build Setting` 中搜索设置 `bitcode` 为 NO就可以了
