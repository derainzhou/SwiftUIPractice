//
//  Sockets.m
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/19.
//

#import "ServerSockets.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/_select.h>
#import <sys/select.h>

#import "IPUtils.h"

@interface ServerSockets()

@property (nonatomic, assign) int serverSock;

@property (nonatomic, assign) int clientSock;

@end

@implementation ServerSockets


+ (instancetype)shared {
    static ServerSockets *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ServerSockets alloc] init];
    });
    return share;
}


- (void)linsten {
    int sock = socket(AF_INET, SOCK_STREAM, 0);

    if(sock == -1){
       close(sock);
       return;
    }
    _serverSock = sock;
    
    // 地址结构体数据，记录ip和端口号
    struct sockaddr_in sockAddr;

    // 声明使用的协议
    sockAddr.sin_family = AF_INET;

    // 获取本机的ip，转换成char类型的 (getIPAddress 稍后再说)
    const char *ip = [[IPUtils getLocalIPAddress:false] UTF8String];

    // 将ip赋值给结构体，inet_addr()函数是将一个点分十进制的IP转换成一个长整数型数
    sockAddr.sin_addr.s_addr = inet_addr(ip);

    // 设置端口号，htons()是将整型变量从主机字节顺序转变成网络字节顺序
    sockAddr.sin_port = htons(12345);

    /*
    * bind函数用于将套接字关联一个地址，返回一个int值，-1为失败
    * 第一个参数指定套接字，就是前面socket函数调用返回额套接字
    * 第二个参数为指定的地址
    * 第三个参数为地址数据的大小
    */

    int bd = bind(sock,(struct sockaddr *) &sockAddr,sizeof(sockAddr));
    if(bd == -1){
        close(sock);
        return;
    }
    
    /*
    * listen函数使用主动连接套接接口变为被连接接口，使得可以接受其他进程的请求，返回一个int值，-1为失败
    * 第一个参数是之前socket函数返回的套接字
    * 第二个参数可以理解为连接的最大限制
    */

    int ls = listen(sock,20);
    if(ls == -1){
      close(sock);
      return;
    }
    
    // 监听客户端响应
    NSThread *recvThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvData) object:nil];
    [recvThread start];
}

- (void)recvData {// 2,等待客户端连接
    
    // 声明一个地址结构体，用于后面接收客户端返回的地址
    struct sockaddr_in recvAddr;
    
    // 地址大小
    socklen_t recv_size =sizeof(struct sockaddr_in);
    
    /*
     * accept()函数在连接成功后会返回一个新的套接字(self.newSock)，用于之后和这个客户端之前收发数据
     * 第一个参数为之前监听的套接字,之前是局部变量，现在需要改为全局的* 第二个参数是一个结果参数，它用来接收一个返回值，这个返回值指定客户端的地址
     * 第三个参数也是一个结果参数，它用来接收recvAddr结构体的代销，指明其所占的字节数
     */
    
    _clientSock = accept(_serverSock,(struct sockaddr *) &recvAddr,&recv_size);
    
    // 3，来到这里就代表已经连接到一个新的客户端，下面就可以进行收发数据了，主要用到了send()和recv()函数
    
    ssize_t bytesRecv = -1;// 返回数据字节大小
    
    
    char recvData[128] ="";// 返回数据缓存区
    
    // 如果一端断开连接，recv就会马上返回，bytesrecv等于0，然后while循环就会一直执行,所以判断等于0是跳出去
    while(YES){
        bytesRecv = recv(_clientSock,recvData, 128, 0);
        // recvData为收到的数据
        if(bytesRecv == 0){
            break;
        }
    }
}

- (void)sendMessage {
    char sendData[32] ="hello client";
    ssize_t size_t = send(_clientSock, sendData,strlen(sendData), 0);
}

@end
