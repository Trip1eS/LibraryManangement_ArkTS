import router from '@ohos.router';
import { DataController } from '../Data';

@Entry
@Component
struct Index {
  aboutToAppear() {
    if (!AppStorage.Has('data')) {
      AppStorage.SetOrCreate('data', new DataController());
    }
  }

  build() {
    Row() {
      Column({ space: 20 }) {
        Text('图书借阅系统')
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Button("借书", { type: ButtonType.Normal })
          .borderRadius(10)
          .width('50%')
          .height(50)
          .fontSize(30)
          .onClick(() => {
            router.push({ url: 'pages/Borrow' })
          })
        Button("还书", { type: ButtonType.Normal })
          .borderRadius(10)
          .width('50%')
          .height(50)
          .fontSize(30)
          .onClick(() => {
            router.push({ url: 'pages/Return' })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}