import mediapipe as mp2
mp = mp2.solutions.mediapipe.python
import cv2
import time

cap = cv2.VideoCapture(0)

mp_hands = mp.solutions.hands
hands = mp_hands.Hands()
mp_draw = mp.solutions.drawing_utils

pTime = 0
cTime = 0

while True:
    success, img = cap.read()
    imgRGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = hands.process(imgRGB)
    # print(results.multi_hand_landmarks)

    if results.multi_hand_landmarks:
        for hand_lms in results.multi_hand_landmarks:
            mp_draw.draw_landmarks(img, hand_lms, mp_hands.HAND_CONNECTIONS)
            for id, lm in enumerate(hand_lms.landmark):
                # print(id, lm)
                # 화면의 비율을 추출하여 landmarks들의 위치를 찾는다.
                h, w, c = img.shape
                cx, cy = int(lm.x*w), int(lm.y*h)
                print(id, cx, cy)
                
                if id == 0: # 특정 landmark 지정
                    cv2.circle(img, (cx, cy), 15, (255, 0, 255), cv2.FILLED)

    cTime = time.time()
    fps = 1/(cTime - pTime)
    pTime = cTime

    cv2.putText(img, str(int(fps)), (10, 70), cv2.FONT_HERSHEY_PLAIN, 3, (255,0,0), 3)

    cv2.imshow('img', img)
    cv2.waitKey(1)