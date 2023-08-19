//
//  ClientSockets.m
//  CS193p
//
//  Created by WisidomCleanMaster on 2023/8/19.
//

#import "ClientSockets.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/_select.h>
#import <sys/select.h>
@import Darwin;

#import "IPUtils.h"

@interface ClientSockets()

@property (nonatomic, assign) int serverSock;

@property (nonatomic, assign) int clientSock;

@end

@implementation ClientSockets

+ (instancetype)shared {
    static ClientSockets *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ClientSockets alloc] init];
    });
    return share;
}

- (void)connect {
    int sock = socket(AF_INET, SOCK_STREAM,0);
    if(sock == -1){
        NSLog(@"Sockets: socket error : %d",sock);
        return;
    }
    _clientSock = sock;
    
    NSString *host = [IPUtils getLocalIPAddress:false];

    // 返回对应于给定主机名的包含主机名字和地址信息的hostent结构指针
    struct hostent *remoteHostEnt = gethostbyname([host UTF8String]);

    if(remoteHostEnt == NULL){
        close(sock);
        NSLog(@"Sockets: 无法解析服务器主机名");
        return;
    }
    // 配置套接字将要连接主机的ip地址和端口号，用于connect()函数

    struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];

    struct sockaddr_in socketPram;
    socketPram.sin_family = AF_INET;
    socketPram.sin_addr = *remoteInAddr;
    socketPram.sin_port = htons(12345);
    
    /*
    * connect函数通常用于客户端简历tcp连接，连接指定地址的主机，函数返回一个int值，-1为失败
    *第一个参数为socket函数创建的套接字，代表这个套接字要连接指定主机
    * 第二个参数为套接字sock想要连接的主机地址和端口号
    * 第三个参数为主机地址大小
    */

    int con = connect(sock, (struct sockaddr *) &socketPram,sizeof(socketPram));

    if(con == -1){
        close(sock);
        NSLog(@"Sockets: 连接失败");
        return;
    }

    NSLog(@"Sockets: 连接成功");
    
    // 监听服务端响应
    NSThread *recvThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvData) object:nil];
    [recvThread start];
}

- (void)sendMessage {
    // 发送数据
    char sendData[32] ="hello service";
    ssize_t size_t= send(_serverSock, sendData,strlen(sendData), 0);
    NSLog(@"Sockets: %zd",size_t);
}

- (void)recvData {
    // 接受数据，放在子线程
    ssize_t bytesRecv = -1;
    char recvData[32] ="";
    while(YES) {
        bytesRecv = recv(_clientSock, recvData, 32, 0);
        NSLog(@"Sockets: %zd %s",bytesRecv,recvData);
        if(bytesRecv == 0) {
            break;
        }
    }
}
@end
