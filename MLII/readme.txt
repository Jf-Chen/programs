程序流程

finalProgram.m包含getFeature函数
getFeature用于提取特征，针对单个60s信号某一导联，得出一组特征
特征暂定为平均RR间期，平均RR波峰，

test调用finalProgram,每一个测试数据调用一次
问：如何形成每个信号的训练集
答:查找REFERENCE.csv,首先查找三个标签，只要有其一符合就归类

问：如何进行交叉验证模块？
答：按顺序分5份，多余的归入最后一份，5可以是输入参数

形成特征集之前，需要先进行去噪，这里用中值滤波去除基线漂移
360Hz的使用200ms和600ms,500Hz的就使用144ms和432ms,就是一个72点一个216点
也许这个理论有出入，最后得到的频率未必是想要的
然后用检测斜率的方式分别检测RR间期
由于不同的Axxxx长度不同，所有一律使用平均信号作为特征，以确保维数一致

getFeature由detectR,detectQ，detectP组成，目前只用这三个信号
具体的做法有点忘了，应该是计算各点斜率，计算斜率的斜率，然后聚类得到拐点

问：如何获取R波峰
答：对slope进行聚类，得到的为1的部分，斜率较大，应该是QRS区段，具体的边界无法确定，
    图像中间的凹陷也难以解释，但是R波一定在这里
	
问：如何获取Q波谷
答：只能完整第走完流程了，不然不好去掉R波和Ron，Roff
    或者分别取出R左边的最低和R右边最低的，取完后画图验证下
	
问：如何使用getFeature，loadData,correctData和combineFeature
答：先加载数据得打data,然后correctData,然后getFeature,
    在finalProgram中多次重复得打多个collection(来自getFeature)
	由separate分离出信号
	由average加工原始特征，取得均值
	经过combineFeature得打由多个单个信号组成的训练集和测试集
	
问：如何完成交叉验证
答：在训练集中按照顺序地分成n份，每份数量取round(k/n)
    9000份数据应当每一个类型都能分成多份
	一共9中类型，最少的202份，最多的1098份
	
问：完整的程序流程如何
答：由finalProgram启动，执行newSeparate->loadData*7000
    ->combineFeature->classifers(oneclassifer*36)

问：getFeature可以得到单个信号的一系列特征，根据beats取均值
final中结合trainSet多次使用
    getFeature可以得到所有需要的collection，通过combineFeature得到
	训练模型所需要的训练矩阵

	
	
getFeature可能出错，去掉endP后排查试试，endP可以跳过错误但是需要知道错误原因
第1668个出错，第3261出错，新建一个testGetFeature进行测试

第6671数据明显有问题，画图可以看出，抛弃不用
问：如何抛弃数据
答：用同类型的文件代替

注：有问题的数据 4765,6671

多次重复finalProgram,在trainFeatures = combineFeature(trainSet,leadway,beats);
出现带有下标的赋值维度不匹配，判断为 getFeature没有问题，需要检测combineFeature

需要先检测一下oneSignalFeature


2018/5/17
顺序执行时出问题的文件：
1225,1670