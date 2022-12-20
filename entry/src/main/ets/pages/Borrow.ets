import router from '@ohos.router';
import { DataController } from '../Data';

@Entry
@Component
struct Borrow {
  private bookId: string = '';
  private readerId: string = '';

  private borrowBook() {
    let data = AppStorage.Get<DataController>('data');
    let book = data.getBook(this.bookId);
    let reader = data.getReader(this.readerId);

    if (book == undefined) {
      AlertDialog.show(
        {
          title: '错误',
          message: '图书编号不存在！请检查后重试。'
        }
      );
      return;
    }

    if (reader == undefined) {
      AlertDialog.show(
        {
          title: '错误',
          message: '读者编号不存在！请检查后重试。'
        }
      );
      return;
    }

    let msg: string =
      '查询到信息如下：' + '\n' +
      '读者姓名：' + reader.name + '\n' +
      '图书名：' + book.name + '\n' +
      '确认借书？';

    AlertDialog.show(
      {
        title: '借书',
        message: msg,
        primaryButton: {
          value: '取消',
          action: () => {
          }
        },
        secondaryButton: {
          value: '确认',
          action: () => this.doBorrow()
        },
        cancel: () => {
        }
      }
    )
  }

  private getDateString(date: Date) {
    return date.getFullYear() + '/' + date.getMonth() + '/' + date.getDay() + ' ' + date.getHours() + ':' + date.getMinutes() + ':' + date.getSeconds();
  }

  private doBorrow() {
    let data = AppStorage.Get<DataController>('data');
    let record = data.addRecord(this.bookId, this.readerId);
    let latestDate = new Date(record.borrowDate);
    latestDate.setSeconds(latestDate.getSeconds() + data.maxBorrowTime);
    let msg: string =
      '您的借阅编号是：' + record.id + '\n' +
      '请于' + this.getDateString(latestDate) + '前凭编号归还';
    AlertDialog.show(
      {
        title: '借阅成功',
        message: msg
      }
    );
  }

  build() {
    Column() {
      Text('借书')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin(10)
      Column({ space: 10 }) {
        Row() {
          Text('书号').fontSize(16).width('30%')
          TextInput({ text: this.bookId }).width('70%').onChange(val => this.bookId = val)
        }

        Row() {
          Text('读者证号').fontSize(16).width('30%')
          TextInput({ text: this.readerId }).width('70%').onChange(val => this.readerId = val)
        }
      }.width('70%')

      Row({ space: 5 }) {
        Button(' 返回 ')
          .onClick(() => router.back())
        Button(' 查询 ')
          .onClick(() => this.borrowBook())
      }.margin(10)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}