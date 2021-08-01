import cv2
import mediapipe as mp2
mp = mp2.solutions.mediapipe.python
import time
import HandTrackingModule as htm

pTime = 0
cTime = 0
cap = cv2.VideoCapture(0)
detector = htm.handDetector()

while True:
    success, img = cap.read()
    img = detector.findHands(img, False)
    lmList = detector.findPosition(img, 0, False)
    if len(lmList) != 0:
        print(lmList[4])

    cTime = time.time()
    fps = 1/(cTime - pTime)
    pTime = cTime

    cv2.putText(img, str(int(fps)), (10, 70), cv2.FONT_HERSHEY_PLAIN, 3, (255,0,0), 3)

    cv2.imshow('img', img)
    cv2.waitKey(1)