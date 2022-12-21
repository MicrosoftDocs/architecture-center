AI on the edge is one of the most popular edge scenarios. Implementations of this scenario include image classification, object detection, body, face and, gesture analysis, and image manipulation. This architecture guide describes how to use Azure IoT Edge to support these scenarios. You can improve AI accuracy by updating the AI model, but in some scenarios the edge device network environment isn't good. For example, in the wind power and oil industries, equipment might be located in the desert or the ocean.

IoT Edge modules are based on Docker. An IoT Edge module image for an AI environment is typically sized at least at the GB level, so incremental updates to the AI model in a narrow-bandwidth network are important. That consideration is the main focus of this article. The idea is to create an IoT Edge AI module that can load TensorFlow or Open Neural Network Exchange (ONNX) object detection models and enable this module as a web API. Doing so enables the IoT Edge module to benefit other applications or modules.

The solution described in this article can help you in these ways:

- Enable AI inference on edge devices.
- Minimize the network cost of deploying and updating AI models on the edge. The solution can save money for you or your customers, especially in a narrow-bandwidth network environment.
- Create and manage an AI model repository in an IoT edge device's local storage.
- Achieve almost zero downtime when the edge device switches AI models.

This article describes how to build an IoT Edge module that can download an AI model and then enable machine learning inference. It describes the TensorFlow **.tflite* format model and the **.onnx* format model.

The next two sections clarify some concepts about machine learning inference modules, TensorFlow Lite, and ONNX.

TensorFlow

- **.tflite* is a pre-trained AI model. You can download it from [TensorFlow.org](https://www.tensorflow.org/lite/examples/object_detection/overview). It's a generic AI model format that you can use in cross-platform applications like iOS and Android. For more information about metadata and associated fields (for example, *labels.txt*) see [Read the metadata from models](https://www.tensorflow.org/lite/models/convert/metadata#read_the_metadata_from_models).
- An object detection model is trained to detect the presence and location of multiple classes of objects. For example, a model might be trained with images that contain various pieces of fruit, along with a label that specifies the class of fruit that they represent (for example, apple) and data that specifies where each object appears in the image.

  When an image is provided to the model, it outputs a list of the objects that it detects, the location of a bounding box that contains each object, and a score that indicates the confidence in the detection.
- If you want to build or custom-tune an AI model, see [TensorFlow Lite Model Maker](https://www.tensorflow.org/lite/models/modify/model_maker).
- You can get more free pre-trained detection models, with a variety of latency and precision characteristics, at [Detection Zoo](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf1_detection_zoo.md#mobile-models). Each model uses the input and output signatures described in the following sections.

ONNX

ONNX is an open-standard format for representing machine learning models. It's supported by a community of partners who have implemented it in many frameworks and tools.

- ONNX supports tools for building and deploying models and for accomplishing other tasks. For more information see, [Supported ONNX tools](https://onnx.ai/supported-tools.html).
- You can use ONNX runtime to run ONNX pre-trained models. For information about a collection of pre-trained models, see [ONNX Model Zoo](https://github.com/onnx/models).
- In this scenario, you can use an object detection and image segmentation model: [Tiny YOLOv3](https://github.com/onnx/models/tree/main/vision/object_detection_segmentation/tiny-yolov3).

The ONNX community [provides tools](https://onnx.ai/supported-tools.html) to help you create and deploy your deep learning model.

## Architecture

The dynamically loaded AI model is based on the features of IoT Edge module twins.

image

link

Comments:

1.	You can download pre-trained AI models from TensorFlow [Detection Zoo](https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/tf1_detection_zoo.md#mobile-models) or [ONNX Model Zoo](https://github.com/onnx/models), or you can also use your own AI model maybe it was built by AML. Then upload Pre-Trained AI Models to public blob storage (Or any other Web service, just for the Edge Module can access this resource and download to Edge device later. You can also consider private endpoint connections between blob storage and Edge device if you need better security.)
2.	The IoT Hub will sync device module twins automatically with AI Models information, the sync will be done even if IoT Edge was offline for some time(In some cases, IoT devices are connected to networks at scheduled times (hourly, daily or weekly) to save power or network traffic).
3.	The Loader Module monitors the updates of module twins via SDK. Through this way, it can get the ML model SAS token, and then download the AI model. 
    - [Create SAS token for a container or blob](https://learn.microsoft.com/azure/storage/blobs/sas-service-create?tabs=dotnet)
    - The **ExpiresOn** property allows you to set the access time of resources. If your device will offline for a long time, you can extend the expiration time.
4.	The Loader Module saves the AI model in the shared local storage of the IoT Edge Module. The shared local storage needs to be configured in the IoT Edge deployment JSON file.
5.	The Loader Module loads the AI model from the local storage by TensorFlow/ONNX SDK.
6.	The Loader Module starts a Web API that receives the binary photo via post request and returns results in json file

In case for update AI model we can upload new AI model to blob storage and sync device module twins again instead of update whole IoT Edge module image, so this is the AI model incremental updates.

Download trained AI model

Here I recommend using device twin to receive notifications that a new model is ready. Even when the device is offline, the message can still be cached in the IoT Hub to wait for the Edge device to come back, and the message will be automatically synchronized.

Here is a code example of the python code used to register notifications for device twin then download AI model as a zip package. And perform further operations on the downloaded file.

1.	The device twin notification was received, which included the file name (File name You can include version information such as 1.0, 1.1, or 2.0), file download address, and MD5 authentication token.
2.	Download AI model as zip file to local storage.
3.	MD5 checksum (optional) MD5 verification prevents zip files that have been tampered with in network transmission.
4.	Unzip it and save it locally.
5.	Send notifications to IoT Hub or routing message to inform that the new AI model is ready.

```
# define behavior for receiving a twin patch
async def twin_patch_handler(patch):
    try:
        print( "######## The data in the desired properties patch was: %s" % patch)
        if "FileName" in patch:
            FileName = patch["FileName"]
        if "DownloadUrl" in patch:
            DownloadUrl = patch["DownloadUrl"]
        if "ContentMD5" in patch:
            ContentMD5 = patch["ContentMD5"]
        FilePath = "/iotedge/storage/" + FileName

        # download AI model
        r = requests.get(DownloadUrl)
        print ("######## download AI Model Succeeded.")
        ffw = open(FilePath, 'wb')
        ffw.write(r.content)
        ffw.close()
        print ("######## AI Model File: " + FilePath)

        # MD5 checksum
        md5str = content_encoding(FilePath)
        if md5str == ContentMD5:
            print ( "######## New AI Model MD5 checksum succeeded")
            # decompressing the ZIP file
            unZipSrc = FilePath
            targeDir = "/iotedge/storage/"
            filenamenoext = get_filename_and_ext(unZipSrc)[0]
            targeDir = targeDir + filenamenoext
            unzip_file(unZipSrc,targeDir)
            
            # ONNX
            local_model_path = targeDir + "/tiny-yolov3-11.onnx"
            local_labelmap_path = targeDir + "/coco_classes.txt"

            # TensorFlow flite
            # local_model_path = targeDir + "/ssd_mobilenet_v1_1_metadata_1.tflite"
            # local_labelmap_path = targeDir + "/labelmap.txt"

            # message to module
            if client is not None:
                print ( "######## Send AI Model Info AS Routing Message")
                data = "{\"local_model_path\": \"%s\",\"local_labelmap_path\": \"%s\"}" % (filenamenoext+"/tiny-yolov3-11.onnx", filenamenoext+"/coco_classes.txt")
                await client.send_message_to_output(data, "DLModelOutput")
                # update the reported properties
                reported_properties = {"LatestAIModelFileName": FileName }
                print("######## Setting reported LatestAIModelName to {}".format(reported_properties["LatestAIModelFileName"]))
                await client.patch_twin_reported_properties(reported_properties)
        else:
            print ( "######## New AI Model MD5 checksum failed")

    except Exception as ex:
        print ( "Unexpected error in twin_patch_handler: %s" % ex )
```

Inference Procedure

After the download of the AI model the next step is to use the model on the Edge device, we can dynamically load and Object Detection on Edge devices. The following code can help us use the TensorFlow AI model to do Object Detection on Edge device.
1.	Dynamic load TensorFlow flite AI MODEL.
2.	Image standardization.
3.	Object detection
4.	Detection scores for the result

```
class InferenceProcedure():
    
    def detect_object(self, imgBytes):

        results = []
        try:
            model_full_path = AI_Model_Path.Get_Model_Path()
            if(model_full_path == ""):
                raise Exception ("PLEASE SET AI MODEL FIRST")
            if '.tflite' in model_full_path:
                interpreter = tf.lite.Interpreter(model_path=model_full_path)
                interpreter.allocate_tensors()
                input_details = interpreter.get_input_details()
                output_details = interpreter.get_output_details()
                input_shape = input_details[0]['shape']

                # bytes to numpy.ndarray
                im_arr = np.frombuffer(imgBytes, dtype=np.uint8)
                img = cv2.imdecode(im_arr, flags=cv2.IMREAD_COLOR)
                im_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
                im_rgb = cv2.resize(im_rgb, (input_shape[1], input_shape[2]))
                input_data = np.expand_dims(im_rgb, axis=0)

                interpreter.set_tensor(input_details[0]['index'], input_data)
                interpreter.invoke()
                output_data = interpreter.get_tensor(output_details[0]['index'])
                detection_boxes = interpreter.get_tensor(output_details[0]['index'])
                detection_classes = interpreter.get_tensor(output_details[1]['index'])
                detection_scores = interpreter.get_tensor(output_details[2]['index'])
                num_boxes = interpreter.get_tensor(output_details[3]['index'])

                label_names = [line.rstrip('\n') for line in open(AI_Model_Path.Get_Labelmap_Path())]
                label_names = np.array(label_names)
                new_label_names = list(filter(lambda x : x != '???', label_names))

                for i in range(int(num_boxes[0])):
                    if detection_scores[0, i] > .5:
                        class_id = int(detection_classes[0, i])
                        class_name = new_label_names[class_id]
                        # top,	left,	bottom,	right
                        results_json = "{'Class': '%s','Score': '%s','Location': '%s'}" % (class_name, detection_scores[0, i],detection_boxes[0, i])
                        results.append(results_json)
                        print(results_json)
        except Exception as e:
            print ( "detect_object unexpected error %s " % e )
            raise

        # return results
        return json.dumps(results)
```
For the ONNX version the process steps are exactly the same, here is the sample code for ONNX, the only difference is how to handle scores result, because the Labelmap and model output parameters are different.

```
class InferenceProcedure():

    def letterbox_image(self, image, size):
        '''resize image with unchanged aspect ratio using padding'''
        iw, ih = image.size
        w, h = size
        scale = min(w/iw, h/ih)
        nw = int(iw*scale)
        nh = int(ih*scale)

        image = image.resize((nw,nh), Image.BICUBIC)
        new_image = Image.new('RGB', size, (128,128,128))
        new_image.paste(image, ((w-nw)//2, (h-nh)//2))
        return new_image

    def preprocess(self, img):
        model_image_size = (416, 416)
        boxed_image = self.letterbox_image(img, tuple(reversed(model_image_size)))
        image_data = np.array(boxed_image, dtype='float32')
        image_data /= 255.
        image_data = np.transpose(image_data, [2, 0, 1])
        image_data = np.expand_dims(image_data, 0)
        return image_data

    def detect_object(self, imgBytes):
        results = []
        try:
            model_full_path = AI_Model_Path.Get_Model_Path()
            if(model_full_path == ""):
                raise Exception ("PLEASE SET AI MODEL FIRST")
            if '.onnx' in model_full_path:

                # input
                image_data = self.preprocess(imgBytes)
                image_size = np.array([imgBytes.size[1], imgBytes.size[0]], dtype=np.float32).reshape(1, 2)

                labels_file = open(AI_Model_Path.Get_Labelmap_Path())
                labels = labels_file.read().split("\n")

                # Loading ONNX model
                print("loading Tiny YOLO...")
                start_time = time.time()
                sess = rt.InferenceSession(model_full_path)
                print("loaded after", time.time() - start_time, "s")

                input_name00 = sess.get_inputs()[0].name
                input_name01 = sess.get_inputs()[1].name
                pred = sess.run(None, {input_name00: image_data,input_name01:image_size})
 
                boxes = pred[0]
                scores = pred[1]
                indices = pred[2]

                results = []
                out_boxes, out_scores, out_classes = [], [], []
                for idx_ in indices[0]:
                    out_classes.append(idx_[1])
                    out_scores.append(scores[tuple(idx_)])
                    idx_1 = (idx_[0], idx_[2])
                    out_boxes.append(boxes[idx_1])
                    results_json = "{'Class': '%s','Score': '%s','Location': '%s'}" % (labels[idx_[1]], scores[tuple(idx_)],boxes[idx_1])
                    results.append(results_json)
                    print(results_json)

        except Exception as e:
            print ( "detect_object unexpected error %s " % e )
            raise

        # return results
        return json.dumps(results)
```

Well, if your IoT Edge Device incorporates the above code and features, then congratulations, your Edge device has AI image object detection capability and supports dynamic updating of AI models. So next, if you want the Edge module to be able to provide AI ability to other applications or modules as Web API then you can create a Web API in your module.

Flask framework, for example, allows you to build an API quickly. You can receive images as binary then use AI model for detection and return results in json format.
Learn more about [Flask: Flask Tutorial in Visual Studio Code](https://code.visualstudio.com/docs/python/tutorial-flask)

Reference

- Understand and use module twins in IoT Hub
- Learn how to deploy modules and establish routes in IoT Edge
- Give modules access to a device's local storage 
- Understand IoT Edge automatic deployments for single devices or at scale
- Open Neural Network Exchange
- ONNX Tutorials
- Deploy ML model on IoT and edge devices
