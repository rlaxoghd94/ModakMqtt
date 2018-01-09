//
//  ViewController.swift
//  ModakMqttTest
//
//  Created by Nic Taehong Kim on 2018. 1. 9..
//  Copyright © 2018년 ex_payday. All rights reserved.
//

import UIKit
import RMQClient

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.send()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func send() {
        let conn = RMQConnection(uri: "amqp://modak.world:1883",
                                delegate: RMQConnectionDelegateLogger())
        conn.start()
        let ch = conn.createChannel()
        let x = ch.topic("topic_logs")
        let msg = "hi"
        x.publish(msg.data(using: .utf8))
        print("Sent '\(msg)'")
        conn.close()
    }
    
    func receive() {
        print("Attempting to connect to local RabbitMQ broker")
        let conn = RMQConnection(delegate: RMQConnectionDelegateLogger())
        conn.start()
        let ch = conn.createChannel()
        let q = ch.queue("hello")
        print("Waiting for messages.")
        q.subscribe({(_ message: RMQMessage) -> Void in
            print("Received \(String(data: message.body, encoding: String.Encoding.utf8)!)")
        })
    }

}

