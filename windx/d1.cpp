/* Подключение заголовочных файлов с описанимями базовых функций windows и Direct3D */
#include <windows.h>
#include <windowsx.h>
#include <d3d9.h>
#include <d3dx9.h>
#include <d3dx9shape.h>
#include <dinput.h>
/*
http://www.cplusplus.com/forum/windows/108166/
http://www.intuit.ru/studies/courses/1120/175/lecture/4756?page=1
https://stackoverflow.com/questions/3899448/c-directx-9-mesh-texture
   +sphere
   +texture
   +animation rotate
   lightning
   material
   input move
   sattelite
   rings
   starts box
https://www.braynzarsoft.net/viewtutorial/q16390-20-cube-mapping-skybox
*/

#define SCREEN_WIDTH 800
#define SCREEN_HEIGHT 600
/* Подключение библиотеки Direct3D */
#pragma comment (lib, "d3d9.lib")
#pragma comment (lib, "d3dx9.lib")
#pragma comment (lib, "dinput.lib")

/* Глобальные объявления */
LPDIRECT3D9 d3d;    // Указатель на COM интерфейс Direct3D
LPDIRECT3DDEVICE9 d3ddev;    // Указатель на класс устройства
LPDIRECT3DVERTEXBUFFER9 v_buffer = NULL;    // the pointer to the vertex buffer
LPDIRECT3DTEXTURE9 saturnTexture;
LPDIRECT3DTEXTURE9 titanTexture;
LPDIRECTINPUT dinput;

/* Прототипы функций */
void initD3D(HWND hWnd);    // Функция настроийки и инициализации Direct3D
void render_frame(void);    // Функция отображения одного кадра
void cleanD3D(void);    // Функция закрытия Direct3D и освобождения памяти
void init_graphics(void);
LPD3DXMESH CreateMappedSphere(LPDIRECT3DDEVICE9 pDev,float fRad,UINT slices,UINT stacks);

struct CUSTOMVERTEX {FLOAT X, Y, Z; DWORD COLOR;};
#define CUSTOMFVF (D3DFVF_XYZ | D3DFVF_DIFFUSE)

/* Прототип функции обработчика оконных сообщений */
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
    //DirectInputCreate(hInstance, DIRECTINPUT_VERSION, &dinput, NULL);

    MSG msg;
    // Главный цикл обработки сообщений и отрисовки
    while(TRUE) {
        while(PeekMessage(&msg, NULL, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }

        if(msg.message == WM_QUIT)
            break;

        render_frame();
    }

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


/* Функция настроийки и инициализации Direct3D */
void initD3D(HWND hWnd) {
    d3d = Direct3DCreate9(D3D_SDK_VERSION);    // создание интерфейса D3D

    D3DPRESENT_PARAMETERS d3dpp;    // Создание структуры информции устройства

    ZeroMemory(&d3dpp, sizeof(d3dpp));    // Очистка структуры перед использованием
    d3dpp.Windowed = TRUE;    // Включение оконного режима
    d3dpp.SwapEffect = D3DSWAPEFFECT_DISCARD;    // Включение отбрасывания старых кадров
    d3dpp.hDeviceWindow = hWnd;    // Установка окна которое будет использовано для Direct3D
    d3dpp.BackBufferFormat = D3DFMT_X8R8G8B8;
    d3dpp.BackBufferWidth = SCREEN_WIDTH;
    d3dpp.BackBufferHeight = SCREEN_HEIGHT;

    d3dpp.EnableAutoDepthStencil = TRUE;
    d3dpp.AutoDepthStencilFormat = D3DFMT_D16;

    // Создать класс устройства используя информацию из структуры d3dpp
    d3d->CreateDevice(D3DADAPTER_DEFAULT,
                      D3DDEVTYPE_HAL,
                      hWnd,
                      D3DCREATE_SOFTWARE_VERTEXPROCESSING,
                      &d3dpp,
                      &d3ddev);

    init_graphics();
    d3ddev->SetRenderState(D3DRS_LIGHTING, FALSE);    // turn off the 3D lighting
    d3ddev->SetRenderState(D3DRS_ZENABLE, TRUE);    // Включить z-буффер
}

void init_graphics(void)
{
    // create a vertex buffer interface called v_buffer
    d3ddev->CreateVertexBuffer(3*sizeof(CUSTOMVERTEX),
                               0,
                               CUSTOMFVF,
                               D3DPOOL_MANAGED,
                               &v_buffer,
                               NULL);

    // create the vertices using the CUSTOMVERTEX struct
    /*
    CUSTOMVERTEX vertices[] = 
    {
        { 3.0f, -3.0f, 0.0f, D3DCOLOR_XRGB(0, 0, 255), },
        { 0.0f, 3.0f, 0.0f, D3DCOLOR_XRGB(0, 255, 0), },
        { -3.0f, -3.0f, 0.0f, D3DCOLOR_XRGB(255, 0, 0), },
    };

    VOID* pVoid;    // a void pointer

    // lock v_buffer and load the vertices into it
    v_buffer->Lock(0, 0, (void**)&pVoid, 0);
    memcpy(pVoid, vertices, sizeof(vertices));
    v_buffer->Unlock();
    */

    // texture
    D3DXCreateTextureFromFile(d3ddev, "./saturn.jpg", &saturnTexture);
    D3DXCreateTextureFromFile(d3ddev, "./titan.jpg", &titanTexture);
}

/* Функция отображения одного кадра */
void render_frame(void) {
    // Очистка экрана
    d3ddev->Clear(0, NULL, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0, 0, 0), 1.0f, 0);
    d3ddev->Clear(0, NULL, D3DCLEAR_ZBUFFER, D3DCOLOR_XRGB(0, 0, 0), 1.0f, 0);

    d3ddev->BeginScene();    // Начало 3D сцены

        // select which vertex format we are using
        d3ddev->SetFVF(CUSTOMFVF);
        
        // SET UP THE PIPELINE
        D3DXMATRIX matRotateY;    // a matrix to store the rotation information
        static float index = 0.0f; index+=0.02f;    // an ever-increasing float value
        // build a matrix to rotate the model based on the increasing float value
        D3DXMatrixRotationY(&matRotateY, index);
        // tell Direct3D about our matrix
        d3ddev->SetTransform(D3DTS_WORLD, &matRotateY);
        D3DXMATRIX matView;    // the view transform matrix
        D3DXVECTOR3 camPos = D3DXVECTOR3 (0.0f, 0.0f, 10.0f);    // the camera position
        D3DXVECTOR3 lookAt = D3DXVECTOR3 (0.0f, 0.0f, 0.0f);    // the look-at position
        D3DXVECTOR3 upDir = D3DXVECTOR3 (0.0f, 1.0f, 0.0f);    // the up direction
        D3DXMatrixLookAtLH(&matView,
                           &camPos,
                           &lookAt,
                           &upDir);
        d3ddev->SetTransform(D3DTS_VIEW, &matView);    // set the view transform to matView
        D3DXMATRIX matProjection;     // the projection transform matrix
        D3DXMatrixPerspectiveFovLH(&matProjection,
                                   D3DXToRadian(45),    // the horizontal field of view
                                   (FLOAT)SCREEN_WIDTH / (FLOAT)SCREEN_HEIGHT, // aspect ratio
                                   1.0f,    // the near view-plane
                                   100.0f);    // the far view-plane
        d3ddev->SetTransform(D3DTS_PROJECTION, &matProjection);    // set the projection


        // select the vertex buffer to display
        //d3ddev->SetStreamSource(0, v_buffer, 0, sizeof(CUSTOMVERTEX));

        d3ddev->SetTexture(0, saturnTexture);
        d3ddev->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
        d3ddev->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);

        // copy the vertex buffer to the back buffer
        //d3ddev->DrawPrimitive(D3DPT_TRIANGLELIST, 0, 1);

    LPD3DXMESH sphere;
    sphere = CreateMappedSphere(d3ddev, 1.0f, 32, 32);
    sphere->DrawSubset(0);

    D3DXMATRIX matTranslate;
    D3DXMATRIX matRotateX;

    D3DXMatrixTranslation(&matTranslate, 4.0f, 0.0f, 0.0f);
    D3DXMatrixRotationY(&matRotateX, index * 2);

    D3DXMATRIX xy = matRotateY * matTranslate * matRotateX;
    d3ddev->SetTransform(D3DTS_WORLD, &xy);

    d3ddev->SetTexture(0, titanTexture);
    d3ddev->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    d3ddev->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);

    LPD3DXMESH titan;
    titan = CreateMappedSphere(d3ddev, 0.3f, 32, 32);
    titan->DrawSubset(0);

    d3ddev->EndScene();    // Окончание 3D сцены 
    d3ddev->Present(NULL, NULL, NULL, NULL);   // Отобразить созданный кадр на экране
}


/* Функция освобождения ресурсов Direct3D и COM */
void cleanD3D(void) {
    v_buffer->Release();    // close and release the vertex buffer
    d3ddev->Release();    // Закрыть 3D устройство
    d3d->Release();    // Закрыть Direct3D
}

typedef struct {
    D3DXVECTOR3 pos;     // vertex position
    D3DXVECTOR3 norm;    // vertex normal
    float tu;            // texture coordinates
    float tv;
} *LPVERTEX;

#define FVF_VERTEX    D3DFVF_XYZ|D3DFVF_NORMAL|D3DFVF_TEX1

LPD3DXMESH CreateMappedSphere(LPDIRECT3DDEVICE9 pDev,float fRad,UINT slices,UINT stacks) {
    // create the sphere
    LPD3DXMESH mesh;
    if (FAILED(D3DXCreateSphere(pDev,fRad,slices,stacks,&mesh,NULL))) return NULL;
    // create a copy of the mesh with texture coordinates,
    // since the D3DX function doesn't include them
    LPD3DXMESH texMesh;
    if (FAILED(mesh->CloneMeshFVF(D3DXMESH_SYSTEMMEM,FVF_VERTEX,pDev,&texMesh))) return mesh;
    // finished with the original mesh, release it
    mesh->Release();

    // lock the vertex buffer
    LPVERTEX pVerts;
    if (SUCCEEDED(texMesh->LockVertexBuffer(0,(void **) &pVerts))) {

        // get vertex count
        int numVerts=texMesh->GetNumVertices();

        // loop through the vertices
        for (int i=0;i<numVerts;i++) {
            // calculate texture coordinates
            pVerts->tu=asinf(pVerts->norm.x)/D3DX_PI+0.5f;
            pVerts->tv=asinf(pVerts->norm.y)/D3DX_PI+0.5f;
            // go to next vertex
            pVerts++;
        }

        // unlock the vertex buffer
        texMesh->UnlockVertexBuffer();
    }
    
    // return pointer to caller
    return texMesh;
}
