/* Подключение заголовочных файлов с описанимями базовых функций windows и Direct3D */
#include <windows.h>
#include <windowsx.h>
#include <d3d9.h>
#include <d3dx9shape.h>
/*
 *http://www.cplusplus.com/forum/windows/108166/
http://www.intuit.ru/studies/courses/1120/175/lecture/4756?page=1
 * sphere
   texture
   animation rotate
   input move
   sattelite
*/

/* Подключение библиотеки Direct3D */
#pragma comment (lib, "d3d9.lib")

/* Глобальные объявления */
LPDIRECT3D9 d3d;    // Указатель на COM интерфейс Direct3D
LPDIRECT3DDEVICE9 d3ddev;    // Указатель на класс устройства

/* Прототипы функций */
void initD3D(HWND hWnd);    // Функция настроийки и инициализации Direct3D
void render_frame(void);    // Функция отображения одного кадра
void cleanD3D(void);    // Функция закрытия Direct3D и освобождения памяти

/* the WindowProc function prototype */
LRESULT CALLBACK WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);


/* Входная точка для программ Windows */
int WINAPI WinMain(HINSTANCE hInstance,
                   HINSTANCE hPrevInstance,
                   LPSTR lpCmdLine,
                   int nCmdShow) {
    HWND hWnd;
    WNDCLASSEX wc;

    ZeroMemory(&wc, sizeof(WNDCLASSEX));

    wc.cbSize = sizeof(WNDCLASSEX);
    wc.style = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)COLOR_WINDOW;
    wc.lpszClassName = "WindowClass";

    RegisterClassEx(&wc);

    hWnd = CreateWindowEx(0, "WindowClass", "Our First Direct3D Program",
                          WS_OVERLAPPEDWINDOW,
                          300, 300,
                          800, 600,
                          NULL, NULL, hInstance, NULL);

    ShowWindow(hWnd, nCmdShow);

    initD3D(hWnd);

    MSG msg;
    // enter the main loop:
    while(TRUE) {
        while(PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }

        if(msg.message == WM_QUIT)
            break;

        render_frame();
    }

    // clean up DirectX and COM
    cleanD3D();
    return msg.wParam;
}


/* Главный обработчик сообщений */
LRESULT CALLBACK WindowProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
    switch(message) {
        case WM_DESTROY: {
                PostQuitMessage(0);
                return 0;
            } break;
    }

    return DefWindowProc (hWnd, message, wParam, lParam);
}


/* this function initializes and prepares Direct3D for use */
void initD3D(HWND hWnd) {
    d3d = Direct3DCreate9(D3D_SDK_VERSION);    // create the Direct3D interface

    D3DPRESENT_PARAMETERS d3dpp;    // create a struct to hold various device information

    ZeroMemory(&d3dpp, sizeof(d3dpp));    // clear out the struct for use
    d3dpp.Windowed = TRUE;    // program windowed, not fullscreen
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;    // discard old frames
    d3dpp.hDeviceWindow = hWnd;    // set the window to be used by Direct3D

    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;


    // create a device class using this information and the info from the d3dpp stuct
    d3d->CreateDevice(D3DADAPTER_DEFAULT,
                      D3DDEVTYPE_HAL,
                      hWnd,
                      D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                      &d3dpp,
                      &d3ddev);

    d3ddev->SetRenderState(D3DRS_ZENABLE, TRUE);    // turn on the z-buffer
}


/* this is the function used to render a single frame */
void render_frame(void) {
    // clear the window to a deep blue
    d3ddev->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0, 40, 100), 1.0f, 0);
    d3ddev->Clear(0, NULL, D3DCLEAR_ZBUFFER, D3DCOLOR_XRGB(0, 0, 0), 1.0f, 0);

    d3ddev->BeginScene();    // begins the 3D scene
    // do 3D rendering on the back buffer here
    // 	

    LPD3DXMESH sphere;
    D3DXCreateSphere(d3ddev, 1.0f, 16, 16, &sphere, NULL);
    sphere->DrawSubset(0);

    d3ddev->EndScene();    // ends the 3D scene
    d3ddev->Present(NULL, NULL, NULL, NULL);   // displays the created frame on the screen
}


/* Функция освобождения ресурсов Direct3D и COM */
void cleanD3D(void) {
    d3ddev->Release();    // Закрыть 3D устройство
    d3d->Release();    // Закрыть Direct3D
}
