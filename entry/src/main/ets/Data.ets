export class BookInfo {
  id: string;
  name: string;
}

export class ReaderInfo {
  id: string;
  name: string;
}

export class BorrowRecord {
  id: string;
  bookId: string;
  readerId: string;
  borrowDate: Date;
  hasReturned: boolean;
}

export class DataController {
  private books: BookInfo[];
  private readers: ReaderInfo[];
  private records: BorrowRecord[];
  public maxBorrowTime: number; // 为了测试方便，这里表示多少秒会超时

  constructor() {
    this.books = [
      { id: '1', name: 'test1' },
      { id: '2', name: 'test2' }
    ];
    this.readers = [
      { id: '1', name: '张三' },
      { id: '2', name: '李四' }
    ];
    this.records = [];
    this.maxBorrowTime = 10;
  }

  public getBook(id: string) {
    return this.books.find(book => book.id == id);
  }

  public getReader(id: string) {
    return this.readers.find(reader => reader.id == id);
  }

  public addRecord(bookId: string, readerId: string) {
    let record: BorrowRecord = {
      id: this.records.length.toString(),
      bookId: bookId,
      readerId: readerId,
      borrowDate: new Date(),
      hasReturned: false
    };
    this.records.push(record);
    return record;
  }

  public getRecord(recordId: string) {
    return this.records.find(record => record.id == recordId);
  }
}