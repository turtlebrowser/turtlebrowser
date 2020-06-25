#include "Context.h"

#include <QApplication>
#include <QQmlApplicationEngine>
#include <qtwebengineglobal.h>
#include <QQmlContext>

int main(int argc, char *argv[]) {
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
  QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
  QApplication app(argc, argv);

  QtWebEngine::initialize();

  turtle_browser::Context context;

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("licenseModelWebView", context.searchModelWebLicenses());
  engine.rootContext()->setContextProperty("licenseModelToolkit", context.searchModelToolkitLicenses());
  engine.rootContext()->setContextProperty("licenseModelPlatform", context.searchModelPlatformLicenses());
  engine.rootContext()->setContextProperty("licenseModelAll", context.searchModelAllLicenses());
  engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
  QMetaObject::invokeMethod(engine.rootObjects().first(), "start");

  return app.exec();
}
