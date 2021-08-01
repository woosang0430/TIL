import cv2
import time
import os
import HandTrackingModule as htm

wCam, hCam = 640, 480

cap = cv2.VideoCapture(0)
cap.set(3, wCam)
cap.set(4, hCam)

Path = 'FingerImages'
myList = os.listdir(Path)
# print(myList)
overlayList = []
for imPath in myList:
    image = cv2.imread(os.path.join(Path, imPath))
    image = cv2.resize(image, (200, 200))
    # print(image.shape)
    overlayList.append(image)

pTime = 0
h, w, c = overlayList[0].shape

detector = htm.handDetector(detectionCon=0.75)

tipIds = [8, 12, 16, 20]

while True:
    success, img = cap.read()
    img = detector.findHands(img)
    lmList = detector.findPosition(img, draw=False)

    if len(lmList) != 0:
        fingers = []

        # Thumb
        if lmList[4][1] < lmList[4 - 1][1]:
            fingers.append(1)
        else:
            fingers.append(0)

        # 4 Fingers
        for id in tipIds:
            if lmList[id][2] < lmList[id - 2][2]:
                fingers.append(1)
            else:
                fingers.append(0)
        # print(fingers)

        totalFingers = sum(fingers)
        print(totalFingers)

        img[0:h, 0:w] = overlayList[totalFingers-1]

        cv2.rectangle(img, (20, 225), (170, 425), (0, 255, 0), cv2.FILLED)
        cv2.putText(img, str(totalFingers), (45, 375), cv2.FONT_HERSHEY_PLAIN, 10, (255, 0, 0), 25)

    cTime = time.time()
    fps = 1/(cTime - pTime)
    pTime = cTime

    cv2.putText(img, f'FPS : {int(fps)}', (400, 70), cv2.FONT_HERSHEY_PLAIN, 2, (255, 0, 0), 3, )

    cv2.imshow('img', img)
    cv2.waitKey(1)